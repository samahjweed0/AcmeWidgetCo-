# Testing Guide

## All Test Cases

### Specification Test Cases (Required)
These are the 4 test cases from the original specification:

| Test | Items | Calculation | Total |
|------|-------|-------------|-------|
| 1 | B01, G01 | $7.95 + $24.95 + $4.95 delivery | **$37.85** |
| 2 | R01, R01 | $32.95 + $16.48 (50% off) + $4.95 delivery | **$54.37** |
| 3 | R01, G01 | $32.95 + $24.95 + $2.95 delivery | **$60.85** |
| 4 | B01, B01, R01, R01, R01 | $7.95×2 + $32.95×3 - $16.48 discount + free delivery | **$98.27** |

### Additional Test Cases
Extra edge cases to verify the system works correctly:

| Test | Items | Description | Total |
|------|-------|-------------|-------|
| 5 | B01 | Single cheapest item | **$12.90** |
| 6 | R01 | Single red widget | **$37.90** |
| 7 | R01, R01, R01 | Three red widgets (1 pair + 1 full price) | **$85.32** |
| 8 | R01, R01, R01, R01 | Four red widgets (2 pairs discounted) | **$98.84** |
| 9 | G01, G01 | Two green widgets | **$54.85** |
| 10 | R01, R01, G01 | Red pair + green (free delivery) | **$77.32** |
| 11 | G01, G01, G01 | Three green widgets | **$77.80** |
| 12 | B01, B01, B01, B01 | Four blue widgets | **$36.75** |
| 13 | (empty) | Empty basket | **$4.95** |

## How to Run Tests

### Run All Tests
```bash
ruby test_basket.rb
```

This will run all 13 test cases and show:
- ✓ PASS or ✗ FAIL for each test
- Items in the basket
- Expected vs actual totals
- Final summary of passed/failed tests

### Run Examples Only
```bash
ruby example.rb
```

This runs just the 4 specification test cases with simple output.

### Manual Testing
You can also test manually in IRB:

```bash
irb -r ./basket.rb -r ./offers.rb
```

Then in IRB:
```ruby
# Setup
catalogue = { 'R01' => 32.95, 'G01' => 24.95, 'B01' => 7.95 }
delivery_rules = [
  { threshold: 50, cost: 4.95 },
  { threshold: 90, cost: 2.95 }
]
offers = [BuyOneGetSecondHalfPriceOffer.new('R01')]

# Create basket and test
basket = Basket.new(catalogue, delivery_rules, offers)
basket.add('R01')
basket.add('R01')
basket.total  # => 54.37
```

## Understanding the Calculations

### Delivery Rules
- **Under $50**: $4.95 delivery
- **$50 - $89.99**: $2.95 delivery  
- **$90+**: Free delivery

Delivery is calculated on the amount AFTER discounts.

### Red Widget Offer
"Buy one red widget, get the second half price"
- Applies to pairs: 2 items = 1 discount, 3 items = 1 discount, 4 items = 2 discounts
- Half price of R01 ($32.95) = $16.48 (rounded to 2 decimals)

### Example Breakdown (Test 4)
```
Items: B01, B01, R01, R01, R01

Subtotal:
  B01 × 2 = $15.90
  R01 × 3 = $98.85
  Total = $114.75

Discount:
  1 pair of R01 = $16.48 off
  (3 red widgets = 1 pair + 1 full price)

After discount: $114.75 - $16.48 = $98.27
Delivery: FREE (over $90)

Final Total: $98.27
```

## Exit Codes
- `0` = All tests passed
- `1` = One or more tests failed

This is useful for CI/CD pipelines.
