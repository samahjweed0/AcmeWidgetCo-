require_relative 'basket'
require_relative 'offers'

def setup_basket
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

  Basket.new(catalogue, delivery_rules, offers)
end

def test_basket(name, items, expected)
  basket = setup_basket
  items.each { |item| basket.add(item) }
  actual = basket.total
  
  status = (actual == expected) ? '✓ PASS' : '✗ FAIL'
  puts "#{status} - #{name}"
  puts "  Items: #{items.join(', ')}"
  puts "  Expected: $#{'%.2f' % expected}"
  puts "  Actual:   $#{'%.2f' % actual}"
  puts
  
  actual == expected
end

puts "=" * 60
puts "ACME WIDGET CO - BASKET TEST SUITE"
puts "=" * 60
puts

puts "SPECIFICATION TEST CASES:"
puts "-" * 60
test1 = test_basket("Test 1: Basic order under $50", ['B01', 'G01'], 37.85)
test2 = test_basket("Test 2: Two red widgets (offer applies)", ['R01', 'R01'], 54.37)
test3 = test_basket("Test 3: Mixed order under $90", ['R01', 'G01'], 60.85)
test4 = test_basket("Test 4: Large order with free delivery", ['B01', 'B01', 'R01', 'R01', 'R01'], 98.27)

puts "ADDITIONAL TEST CASES:"
puts "-" * 60
test5 = test_basket("Test 5: Single item (cheapest)", ['B01'], 12.90)
test6 = test_basket("Test 6: Single red widget", ['R01'], 37.90)
test7 = test_basket("Test 7: Three red widgets (1 pair + 1 full)", ['R01', 'R01', 'R01'], 85.32)
test8 = test_basket("Test 8: Four red widgets (2 pairs)", ['R01', 'R01', 'R01', 'R01'], 98.84)
test9 = test_basket("Test 9: Two green widgets", ['G01', 'G01'], 54.85)
test10 = test_basket("Test 10: Red pair + green (free delivery)", ['R01', 'R01', 'G01'], 77.32)
test11 = test_basket("Test 11: All green widgets", ['G01', 'G01', 'G01'], 77.80)
test12 = test_basket("Test 12: All blue widgets", ['B01', 'B01', 'B01', 'B01'], 36.75)
test13 = test_basket("Test 13: Empty basket", [], 4.95)

puts "=" * 60
all_tests = [test1, test2, test3, test4, test5, test6, test7, test8, test9, test10, test11, test12, test13]
passed = all_tests.count(true)
total = all_tests.length

puts "RESULTS: #{passed}/#{total} tests passed"
puts "=" * 60

exit(passed == total ? 0 : 1)
