class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :name
      t.string :description
      t.string :feature_type
      t.string :unit
      t.integer :display_order
      t.boolean :use_unit

      t.timestamps null: false
    end
  end
end
