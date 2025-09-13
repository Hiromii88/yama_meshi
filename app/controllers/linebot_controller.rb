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

  def handle_message(event)
    input_calorie = event.message.text.to_i
    recipe = Recipe.where(calories: (input_calorie - 20)..(input_calorie + 20)).order("RANDOM()").first
    recipe ||= Recipe.order("RANDOM()").first

    request = Line::Bot::V2::MessagingApi::ReplyMessageRequest.new(
      reply_token: event.reply_token,
      messages: [
        Line::Bot::V2::MessagingApi::TextMessage.new(
          text: "🎲 結果！\n#{input_calorie} kcalのおすすめは…\n#{recipe.name} (#{recipe.calories} kcal)"
        )
      ]
    )
    client.reply_message(reply_message_request: request)
  end
end
