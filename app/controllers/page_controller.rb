class PageController < ApplicationController

  def index
    @conversations = Conversation.all.order(updated_at: :desc)
  end

end
