class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.string :stripe_id
      t.integer :plan_id
      t.string :last_four
      t.string :card_type
      t.integer :current_price_cents
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
