class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.references  :user
      t.string :workflow_state

      t.timestamps
    end

    create_table :messages do |t|
      t.string   :msg_id
      t.string   :media_url
      t.text     :body
      t.references :conversation

      t.timestamps
    end
  end
end
