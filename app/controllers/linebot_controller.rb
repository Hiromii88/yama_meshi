require 'line-bot-api'

class LinebotController < ApplicationController
  protect_from_forgery with: :null_session

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    begin
      events = parser.parse(body: body, signature: signature)
    rescue Line::Bot::V2::WebhookParser::InvalidSignatureError
      head :bad_request and return
    end

    events.each { |event| handle_event(event) }

    head :ok
  end

  private

  def client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: Rails.application.credentials.dig(:line, :channel_token)
    )
  end

  def parser
    @parser ||= Line::Bot::V2::WebhookParser.new(
      channel_secret: Rails.application.credentials.dig(:line, :channel_secret)
    )
  end

  def handle_event(event)
    case event
    when Line::Bot::V2::Webhook::MessageEvent
      handle_message(event) if event.message.is_a?(Line::Bot::V2::Webhook::TextMessageContent)
    end
  end

  def handle_message(event) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    line_user_id = event.source.user_id
    input_text   = event.message.text.strip

    # 1. 連携コードと一致するか確認
    user = User.find_by(line_link_token: input_text)
    if user
      user.update_columns(line_user_id: line_user_id, line_link_token: nil)
      text = '✅ LINE連携が完了しました！'
    else
      # 2. 数字入力として判定
      input_calorie = input_text.tr('０-９', '0-9').to_i
      form = KcalForm.new(kcal: input_calorie)

      if form.valid?
        recipe = Recipe.where(calories: (input_calorie - 20)..(input_calorie + 20)).order('RANDOM()').first
        recipe ||= Recipe.order('RANDOM()').first

        text = "🎲 結果！\n#{input_calorie} kcalのおすすめは…\n#{recipe.name} (#{recipe.calories} kcal)"
      else
        # 3. それ以外はエラーメッセージ
        text = '⚠️ 数字を入力するか、連携コードを送ってください。'
      end
    end

    # 共通の返信処理
    request = Line::Bot::V2::MessagingApi::ReplyMessageRequest.new(
      reply_token: event.reply_token,
      messages: [Line::Bot::V2::MessagingApi::TextMessage.new(text: text)]
    )
    client.reply_message(reply_message_request: request)
  end
end
