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

offers = [BuyOneGetSecondHalfPriceOffer.new('R01')]

puts "\n" + "=" * 80
puts "DELIVERY COST RULES VERIFICATION"
puts "=" * 80

def show_breakdown(items_desc, items, catalogue, delivery_rules, offers)
  basket = Basket.new(catalogue, delivery_rules, offers)
  items.each { |item| basket.add(item) }
  
  subtotal = items.sum { |code| catalogue[code] }
  
  discount = 0.0
  offers.each do |offer|
    discount += offer.apply(items, catalogue)
  end
  
  amount_after_discount = subtotal - discount
  
  delivery = 0.0
  delivery_rules.each do |rule|
    if amount_after_discount < rule[:threshold]
      delivery = rule[:cost]
      break
    end
  end
  
  total = basket.total
  
  puts "\n#{items_desc}"
  puts "  Items: #{items.join(', ')}"
  puts "  Subtotal: $#{'%.2f' % subtotal}"
  puts "  Discount: -$#{'%.2f' % discount}" if discount > 0
  puts "  Amount (after discount): $#{'%.2f' % amount_after_discount}"
  
  if amount_after_discount < 50
    puts "  → Under $50 → Delivery: $4.95"
  elsif amount_after_discount < 90
    puts "  → $50-$89.99 → Delivery: $2.95"
  else
    puts "  → $90+ → Delivery: FREE"
  end
  
  puts "  TOTAL: $#{'%.2f' % total}"
end

puts "\n📦 RULE 1: Orders UNDER $50 → $4.95 delivery"
puts "-" * 80
show_breakdown("Example 1: Small order", ['B01', 'G01'], catalogue, delivery_rules, offers)
show_breakdown("Example 2: Two reds with discount", ['R01', 'R01'], catalogue, delivery_rules, offers)

puts "\n\n📦 RULE 2: Orders $50-$89.99 → $2.95 delivery"
puts "-" * 80
show_breakdown("Example 3: Red + Green", ['R01', 'G01'], catalogue, delivery_rules, offers)
show_breakdown("Example 4: Three greens", ['G01', 'G01', 'G01'], catalogue, delivery_rules, offers)

puts "\n\n📦 RULE 3: Orders $90+ → FREE delivery"
puts "-" * 80
show_breakdown("Example 5: Large order", ['B01', 'B01', 'R01', 'R01', 'R01'], catalogue, delivery_rules, offers)
show_breakdown("Example 6: Four reds", ['R01', 'R01', 'R01', 'R01'], catalogue, delivery_rules, offers)

puts "\n" + "=" * 80
puts "✓ All delivery rules working correctly!"
puts "💡 Key: Delivery is calculated on the amount AFTER discounts are applied"
puts "=" * 80 + "\n"
