class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.text :uid
      t.text :name
      t.text :token
      t.timestamps
    end
  end
end
