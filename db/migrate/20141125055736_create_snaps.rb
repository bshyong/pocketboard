class CreateSnaps < ActiveRecord::Migration
  def change
    create_table :snaps do |t|
      t.string :msg_id
      t.string :media_url
      t.references :user
      t.text :body

      t.timestamps
    end
  end
end
