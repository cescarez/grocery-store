# Christabel Sebastian
# Last updated, Sept 22, 2020
# Ada C14
# Grocery Store: Order Class

class Order
  FULFILLMENTS = [:pending, :paid, :processing, :shipped, :complete]
  TAX_RATE = .075

  attr_reader :id, :products, :fulfillment_status
  attr_accessor :customer

  def initialize(id_num, customer_name)
    @id = id_num
    @customer = customer_name
    @products = {}
    @fulfillment_status = FULFILLMENTS[0]
  end

  def total
    sub_total = @products.sum {|product, price| price}
    return ((1 + TAX_RATE) * sub_total).round(2)
  end

  def add_product(product_name, price)
    raise ArgumentError, "Invalid price." if (num.to_f == 0 && !num.match(/[0]+[.]?[0]*/))
    raise ArgumentError, "Product was already in Order #{@id} and cannot be added." if @products.include?(product_name)

    @products << { product_name => price.to_f.round(2) }
  end

  def remove_product(product_name)
    raise ArgumentError, "Product, #{product_name}, is not in Order #{@id} and cannot be deleted." if !@products.include?(product_name)

    @products.delete(product_name)
  end

  def pay
    @fulfillment_status = FULFILLMENTS[1]
  end

  def process
    @fulfillment_status = FULFILLMENTS[2]
  end

  def ship
    @fulfillment_status = FULFILLMENTS[-2]
  end

  def deliver
    @fulfillment_status = FULFILLMENTS[-1]
  end

  def check_fulfillment_status(current_status)
    raise ArgumentError, "Invalid order status." if !FULFILLMENTS.include?(current_status)
    return @fulfillment_status
  end

end