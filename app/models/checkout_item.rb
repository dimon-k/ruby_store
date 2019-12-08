class CheckoutItem < Sequel::Model
  many_to_one :checkout
  many_to_one :product
end
