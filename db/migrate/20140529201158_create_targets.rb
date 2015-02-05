class CreateTargets < ActiveRecord::Migration
  def change
    create_table :targets do |t|
      t.references :appliance, index: true
      t.string :hostname
      t.string :address

      t.timestamps
    end
    add_index :targets, :hostname, unique: true
  end
end
