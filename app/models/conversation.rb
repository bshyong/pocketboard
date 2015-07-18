class Conversation < ActiveRecord::Base
  has_many :messages
  belongs_to :user
  include Workflow

  workflow do
    state :open do
      event :assign, transitions_to: :in_progress
    end
    state :in_progress do
      event :close, transitions_to: :closed
    end
    state :closed
  end
end
