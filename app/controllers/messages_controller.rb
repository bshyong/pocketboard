class MessagesController < ApplicationController
  def create
    @conversation = Conversation.find(params[:conversation_id])
    @conversation.messages.create(
      body: params[:body]
    )
    render nothing: true, status: 200
  end
end
