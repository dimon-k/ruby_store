class Product < Sequel::Model
  one_to_many :checkout_items
end
