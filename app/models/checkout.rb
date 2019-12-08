class Checkout < Sequel::Model
  one_to_many :checkout_items

  def initialize(pricing_rules)
    super
    save
  end

  def scan(product)
    CheckoutItem.create(checkout_id: id, product_id: product.id)
  end

  def total
    all_items_sum.round(2)
  end

  private

  def validate
    super
    errors.add(:coffee_promo, 'You are not allowed to change coffee promotion!') unless coffee_promo.nil?
  end

  def all_items_sum
    [green_tea_sum, strawberries_sum, coffee_sum, other_items_sum].sum
  end

  def green_tea_sum(tea_items: products('GR1'))
    return 0 if tea_items.nil?
    return regular_sum(tea_items) unless green_tea_promo

    tea_items.each_with_index.sum { |item, index| index % 2 == 1 ? 0 : item }
  end

  def strawberries_sum(strawberry_items: products('SR1'))
    return 0 if strawberry_items.nil?
    return regular_sum(strawberry_items) unless strawberries_promo && strawberry_items.count >= 3

    strawberry_items.sum { |item| item * 0.9 }
  end

  def coffee_sum(coffee_items: products('CF1'))
    return 0 if coffee_items.nil?
    return regular_sum(coffee_items) unless coffee_promo && coffee_items.count >= 3

    regular_sum(coffee_items) / 3 * 2
  end

  def other_items_sum
    product_ids = [product_id('GR1'), product_id('SR1'), product_id('CF1')]
    other_items = CheckoutItem.where(checkout_id: id).exclude(product_id: product_ids).map(&:product).map(&:price)
    return 0 unless other_items.any?

    regular_sum(other_items)
  end

  def products(product_code)
    CheckoutItem.where(checkout_id: id, product_id: product_id(product_code)).map(&:product).map(&:price)
  end

  def product_id(product_code)
    Product.find(product_code: product_code).id
  end

  def regular_sum(selected_items)
    selected_items.sum
  end
end
