class Basket
  def initialize(catalogue, delivery_rules, offers)
    @catalogue = catalogue
    @delivery_rules = delivery_rules
    @offers = offers
    @items = []
  end

  def add(product_code)
    @items << product_code
  end

  def total
    subtotal = calculate_subtotal
    discount = calculate_discount
    delivery = calculate_delivery(subtotal - discount)
    
    (subtotal + delivery - discount).round(2)
  end

  private

  def calculate_subtotal
    @items.sum { |code| @catalogue[code] }
  end

  def calculate_discount
    discount = 0.0
    
    @offers.each do |offer|
      discount += offer.apply(@items, @catalogue)
    end
    
    discount
  end

  def calculate_delivery(amount_after_discount)
    @delivery_rules.each do |rule|
      return rule[:cost] if amount_after_discount < rule[:threshold]
    end
    
    0.0
  end
end
