class PageController < ApplicationController

  def index
    @count = Snap.count
    @snaps = Snap.all
  end

end
