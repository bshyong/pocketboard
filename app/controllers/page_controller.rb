class PageController < ApplicationController

  def index
    @conversations = Conversation.all
  end

end
