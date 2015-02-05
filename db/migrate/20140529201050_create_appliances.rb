class CreateAppliances < ActiveRecord::Migration
  def change
    create_table :appliances do |t|
      t.string :name
      t.string :customer

      t.timestamps
    end
    add_index :appliances, :name, unique: true
  end
end
