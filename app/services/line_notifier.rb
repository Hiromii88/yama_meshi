require 'line-bot-api'

class LineNotifier
  def self.push_message(user_id:, message:)
    request = Line::Bot::V2::MessagingApi::PushMessageRequest.new(
      to:user_id,
      messages: [
        Line::Bot::V2::MessagingApi::TextMessage.new(text: message)
      ]
    )
    client.push_message(push_message_request: request)
  end

  def self.client
    @client ||= Line::Bot::V2::MessagingApi::ApiClient.new(
      channel_access_token: Rails.application.credentials.dig(:line, :channel_token)
    )
  end
end