class CreateTableCheckouts < Sequel::Migration
  def up
    create_table :checkouts do
      primary_key :id
      Boolean :green_tea_promo, null: false, default: false
      Boolean :strawberries_promo, null: false, default: false
      Boolean :coffee_promo, null: false, default: true
    end
  end

  def down
    drop_table :checkouts
  end
end
