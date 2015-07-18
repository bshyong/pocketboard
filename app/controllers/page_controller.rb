class PageController < ApplicationController

  def index
    @count = Snap.count
    @snaps = Snap.all
    @users = User.all
  end

end
