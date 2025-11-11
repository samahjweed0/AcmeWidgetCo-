# Acme Widget Co - Sales System

A Ruby implementation of a shopping basket system with dynamic pricing, delivery rules, and promotional offers.

## Overview

This system calculates the total cost of a shopping basket, including:
- Product pricing from a catalogue
- Delivery charges based on order value
- Promotional offers (e.g., "buy one red widget, get the second half price")

## How It Works

### Core Components

**Basket (`basket.rb`)**
- Manages items in the shopping basket
- Calculates subtotals, discounts, and delivery charges
- Returns the final total cost

**Offers (`offers.rb`)**
- Implements promotional logic
- `BuyOneGetSecondHalfPriceOffer`: Applies 50% discount to every second item of a specific product

### Pricing Rules

**Products:**
- Red Widget (R01): $32.95
- Green Widget (G01): $24.95
- Blue Widget (B01): $7.95

**Delivery Charges:**
- Orders under $50: $4.95
- Orders $50-$89.99: $2.95
- Orders $90+: Free

**Current Offers:**
- Buy one red widget (R01), get the second half price

## Usage

```ruby
require_relative 'basket'
require_relative 'offers'

# Initialize catalogue
catalogue = {
  'R01' => 32.95,
  'G01' => 24.95,
  'B01' => 7.95
}

# Define delivery rules
delivery_rules = [
  { threshold: 50, cost: 4.95 },
  { threshold: 90, cost: 2.95 }
]

# Set up offers
offers = [
  BuyOneGetSecondHalfPriceOffer.new('R01')
]

# Create basket and add items
basket = Basket.new(catalogue, delivery_rules, offers)
basket.add('B01')
basket.add('G01')

# Get total
puts basket.total # => 37.85
```

## Running the Examples

```bash
ruby example.rb
```

### Expected Output

```
Basket 1 (B01, G01): $37.85
Basket 2 (R01, R01): $54.37
Basket 3 (R01, G01): $60.85
Basket 4 (B01, B01, R01, R01, R01): $98.27
```

## Design Decisions & Assumptions

### Architecture
- **Separation of Concerns**: Basket logic is separated from offer logic, making it easy to add new promotional types
- **Flexible Configuration**: Catalogue, delivery rules, and offers are passed as parameters, allowing easy updates without code changes
- **Extensible Offers**: The offer system uses a simple interface (`apply` method) that can be extended for different promotion types

### Assumptions
1. **Delivery Calculation**: Delivery charges are calculated on the amount *after* discounts are applied
2. **Offer Stacking**: Multiple offers can be applied simultaneously (though currently only one is implemented)
3. **Product Codes**: All product codes are valid; no validation is performed for invalid codes
4. **Pricing Precision**: All calculations use Ruby's float arithmetic; for production, consider using the `BigDecimal` class for financial precision
5. **Offer Order**: The "buy one get second half price" offer applies to pairs in the order items are added (e.g., 3 items = 1 pair + 1 full price)

### Calculation Flow
1. Calculate subtotal from all items
2. Apply all promotional offers to get total discount
3. Calculate delivery charge based on (subtotal - discount)
4. Return final total: subtotal + delivery - discount

## Extending the System

### Adding New Offers

Create a new offer class with an `apply` method:

```ruby
class BuyTwoGetOneFreeOffer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items, catalogue)
    count = items.count(@product_code)
    free_items = count / 3
    free_items * catalogue[@product_code]
  end
end
```

Then add it to the offers array when initializing the basket.

### Modifying Delivery Rules

Simply update the `delivery_rules` array with new thresholds and costs. Rules should be ordered from lowest to highest threshold.

## Testing

The `example.rb` file includes the four test cases from the specification:

| Products | Expected Total |
|----------|----------------|
| B01, G01 | $37.85 |
| R01, R01 | $54.37 |
| R01, G01 | $60.85 |
| B01, B01, R01, R01, R01 | $98.27 |

All test cases pass with the current implementation.
