require 'twilio-ruby'

class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @conversation.messages.create(
      body: params[:body]
    )
    @conversation.assign! if @conversation.messages.where(sender: nil).any?

    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.account.messages.create(
      from: '4085059891',
      to: @conversation.user.phone,
      body: params[:body],
      status_callback: request.base_url + '/twilio/status'
    )

    render nothing: true, status: 200
  end
end
