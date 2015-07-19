class Message < ActiveRecord::Base
  belongs_to :conversation, touch: true
  delegate :user, to: :conversation
  belongs_to :sender, class_name: User
end
