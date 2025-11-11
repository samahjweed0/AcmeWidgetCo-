class BuyOneGetSecondHalfPriceOffer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items, catalogue)
    count = items.count(@product_code)
    pairs = count / 2
    half_price = (catalogue[@product_code] / 2.0).round(2)
    
    pairs * half_price
  end
end
