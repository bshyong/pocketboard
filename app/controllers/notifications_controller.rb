require 'twilio-ruby'

class NotificationsController < ApplicationController

  skip_before_action :verify_authenticity_token

  def notify
    client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    message = client.account.messages.create from: 'AAA', to: 'BBB', body: 'Learning to send SMS you are.', media_url: 'http://linode.rabasa.com/yoda.gif'
    render plain: message.status
  end

  def status
    render plain: request.params['MessageStatus']
  end
end