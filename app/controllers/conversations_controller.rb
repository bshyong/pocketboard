class ConversationsController < ApplicationController
  def show
    @conversation = Conversation.find(params[:id])
    @user = @conversation.user
  end
end
