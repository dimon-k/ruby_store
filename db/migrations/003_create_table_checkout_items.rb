class CreateTableCheckoutItems < Sequel::Migration
  def up
    create_table :checkout_items do
      primary_key :id
      Integer     :checkout_id, null: false
      Integer     :product_id,  null: false
    end
  end

  def down
    drop_table :checkout_items
  end
end
