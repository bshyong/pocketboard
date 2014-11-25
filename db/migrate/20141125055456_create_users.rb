class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :phone
      t.string :country
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
    end
  end
end
