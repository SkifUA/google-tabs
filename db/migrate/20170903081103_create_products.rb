class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.integer :name
      t.string :quantity
      t.text :description

      t.timestamps
    end
  end
end
