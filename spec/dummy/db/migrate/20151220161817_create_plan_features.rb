class CreatePlanFeatures < ActiveRecord::Migration
  def change
    create_table :plan_features do |t|
      t.string :value
      t.string :display_value
      t.integer :plan_id
      t.integer :feature_id

      t.timestamps null: false
    end
  end
end
