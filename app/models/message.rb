class Messages < ActiveRecord::Base
  belongs_to :conversation
  delegate :user, to: :conversation
end
