class CreateTableProducts < Sequel::Migration
  def up
    create_table :products do
      primary_key :id
      String :name, null: false
      String :product_code, null: false
      Float :price, null: false
    end
  end

  def down
    drop_table :products
  end
end
