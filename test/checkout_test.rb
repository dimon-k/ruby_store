require './config/application'
require 'test/unit'

class CheckoutTest < Test::Unit::TestCase
  def setup
    product_items = [{ product_code: 'GR1', name: 'Green tea',    price: 3.11  },
                     { product_code: 'SR1', name: 'Strawberries', price: 5.00  },
                     { product_code: 'CF1', name: 'Coffee',       price: 11.23 }]
    product_items.each { |item| Product.find_or_create(item) }
    @pricing_rules = { green_tea_promo: true, strawberries_promo: true}
  end

  def test_scan
    checkout = scan_checkout_items(['GR1'])
    assert_equal(1, checkout.checkout_items.count)
  end

  def test_total
    checkout = scan_checkout_items(['CF1'])
    assert_equal(11.23, checkout.total)
  end

  def test_green_tea_promo_and_other_items
    checkout = scan_checkout_items(['GR1', 'SR1', 'GR1', 'GR1', 'CF1'])
    assert_equal(22.45, checkout.total)
  end

  def test_green_tea_promo
    checkout = scan_checkout_items(['GR1', 'GR1'])
    assert_equal(3.11, checkout.total)
  end

  def test_strawberries_promo
    checkout = scan_checkout_items(['SR1', 'SR1', 'GR1', 'SR1'])
    assert_equal(16.61, checkout.total)
  end

  def test_coffee_promo
    checkout = scan_checkout_items(['GR1', 'CF1', 'SR1', 'CF1', 'CF1'])
    assert_equal(30.57, checkout.total)
  end
  
  private

  def scan_checkout_items(items_codes)
    checkout = Checkout.new(@pricing_rules)
    items_codes.each { |code| checkout.scan(Product.find(product_code: code)) }
    checkout
  end
end