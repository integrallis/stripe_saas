class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :stripe_id
      t.string :name
      t.integer :price_cents
      t.string :interval
      t.integer :interval_count
      t.integer :trial_period_days
      t.text :metadata_as_json
      t.text :statement_descriptor
      t.text :features_as_json
      t.boolean :highlight
      t.integer :display_order

      t.timestamps null: false
    end
  end
end
