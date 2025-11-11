require_relative 'basket'
require_relative 'offers'

catalogue = {
  'R01' => 32.95,
  'G01' => 24.95,
  'B01' => 7.95
}

delivery_rules = [
  { threshold: 50, cost: 4.95 },
  { threshold: 90, cost: 2.95 }
]

offers = [
  BuyOneGetSecondHalfPriceOffer.new('R01')
]

basket1 = Basket.new(catalogue, delivery_rules, offers)
basket1.add('B01')
basket1.add('G01')
puts "Basket 1 (B01, G01): $#{'%.2f' % basket1.total}"

basket2 = Basket.new(catalogue, delivery_rules, offers)
basket2.add('R01')
basket2.add('R01')
puts "Basket 2 (R01, R01): $#{'%.2f' % basket2.total}"

basket3 = Basket.new(catalogue, delivery_rules, offers)
basket3.add('R01')
basket3.add('G01')
puts "Basket 3 (R01, G01): $#{'%.2f' % basket3.total}"

basket4 = Basket.new(catalogue, delivery_rules, offers)
basket4.add('B01')
basket4.add('B01')
basket4.add('R01')
basket4.add('R01')
basket4.add('R01')
puts "Basket 4 (B01, B01, R01, R01, R01): $#{'%.2f' % basket4.total}"
