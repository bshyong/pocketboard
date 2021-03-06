require 'twilio-ruby'

class TwilioController < ApplicationController
  include Webhookable

  after_filter :set_header

  skip_before_action :verify_authenticity_token

  def voice
  	response = Twilio::TwiML::Response.new do |r|
  	  r.Say 'Hey there sexy. Congrats on integrating Twilio into your Rails 4 app.', :voice => 'alice'
  	  r.Play 'http://linode.rabasa.com/cantina.mp3'
  	end

  	render_twiml response
  end

  def sms
    user = User.where(
      phone: params["From"]
    ).first_or_create

    if user
      user.update_attributes(
        state: params["FromState"],
        zipcode: params["FromZip"],
        city: params["FromCity"],
        country: params["FromCountry"]
      )

      conversation = user.conversations.order(created_at: :desc).first_or_create

      message = conversation.messages.create(
        body: params["Body"],
        media_url: params["MediaUrl0"],
        msg_id: params["MessageSid"],
        sender: user
      )

      media = message.media_url.blank? ? nil : "<img src='#{message.media_url}' />"
      message_body = [media, message.body].compact.join('\n')

      begin
        Pusher.trigger(
          "convo_#{conversation.id}",
          'new_message',
          {
            id: "message_#{message.id}",
            body: "#{message_body}",
            sender_id: "#{user.id}"
          }
        )
      rescue Pusher::Error => e
        # (Pusher::AuthenticationError, Pusher::HTTPError, or Pusher::Error)
      end
    end

    # {"ToCountry"=>"US", "MediaContentType0"=>"image/jpeg", "ToState"=>"CA", "SmsMessageSid"=>"MM9edaa5afd31599a67580c5502636a164", "NumMedia"=>"1", "ToCity"=>"", "FromZip"=>"95156", "SmsSid"=>"MM9edaa5afd31599a67580c5502636a164", "FromState"=>"CA", "SmsStatus"=>"received", "FromCity"=>"SUNNYVALE", "Body"=>"", "FromCountry"=>"US", "To"=>"+13236732344", "ToZip"=>"", "MessageSid"=>"MM9edaa5afd31599a67580c5502636a164", "AccountSid"=>"AC7f1be0408517f1883d7c79c4e82bc40e", "From"=>"+14085059891", "MediaUrl0"=>"https://api.twilio.com/2010-04-01/Accounts/AC7f1be0408517f1883d7c79c4e82bc40e/Messages/MM9edaa5afd31599a67580c5502636a164/Media/ME91bc5abca4262dbdc3e7bf0ea1706b28", "ApiVersion"=>"2010-04-01"}

    # {"ToCountry"=>"US", "ToState"=>"CA", "SmsMessageSid"=>"SM31814be39b481a97743189d478a90657", "NumMedia"=>"0", "ToCity"=>"", "FromZip"=>"95156", "SmsSid"=>"SM31814be39b481a97743189d478a90657", "FromState"=>"CA", "SmsStatus"=>"received", "FromCity"=>"SUNNYVALE", "Body"=>"Testflight", "FromCountry"=>"US", "To"=>"+13236732344", "ToZip"=>"", "MessageSid"=>"SM31814be39b481a97743189d478a90657", "AccountSid"=>"AC7f1be0408517f1883d7c79c4e82bc40e", "From"=>"+14085059891", "ApiVersion"=>"2010-04-01"}
    render nothing: true
  end

  def status
    # Twilio will post to this URL with status info
    smsid = params["SmsSid"]
    msg_status = params["MessageStatus"]
    puts params.inspect
    render nothing: true, status: 200
    # render_twiml Twilio::TwiML::Response.new
  end

end
