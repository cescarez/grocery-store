# Christabel Sebastian
# Last updated, Sept 22, 2020
# Ada C14
# Grocery Store: Order Class
class Order
  VALID_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  TAX_RATE = 0.075

  attr_reader :id, :products, :fulfillment_status
  attr_accessor :customer

  def initialize(id_num, products, customer_object,fulfillment_status = VALID_STATUSES[0])
    @id = id_num
    @customer = customer_object
    @products = (products && !products.empty?) ? products : Hash.new(0)
    @fulfillment_status = check_fulfillment_status(fulfillment_status)
  end

  def check_fulfillment_status(current_status)
    if current_status.class != Symbol
      current_status = current_status.downcase.to_sym
    end

    raise ArgumentError, "Invalid order status." if !VALID_STATUSES.include?(current_status)

    return current_status
  end

  def total
    sub_total = @products.sum {|product_name, price| price}
    return ((1 + TAX_RATE) * sub_total).round(2)
  end

  def add_product(product_name, price)
    product_name = product_name.downcase

    raise ArgumentError, "Invalid price." if (price.to_f == 0 && !price.match(/[d]+[.]?[d]*/))
    raise ArgumentError, "Product was already in Order #{@id} and cannot be added." if @products.include?(product_name)

    @products[product_name] = price.to_f.round(2)
  end

  def remove_product(product_name)
    product_name = product_name.downcase

    raise ArgumentError, "Product, #{product_name}, is not in Order #{@id} and cannot be deleted." if !@products.include?(product_name)

    @products.delete(product_name)
  end
  #
  # def pay
  #   @fulfillment_status = VALID_STATUSES[1]
  # end
  #
  # def process
  #   @fulfillment_status = VALID_STATUSES[2]
  # end
  #
  # def ship
  #   @fulfillment_status = VALID_STATUSES[-2]
  # end
  #
  # def deliver
  #   @fulfillment_status = VALID_STATUSES[-1]
  # end

  def self.all
    external_orders_file = CSV.read('data/orders.csv').map { |row| row.to_a }
    #id, customer object, product hash, status

    all_products = []
    external_orders_file.each do |order|
      this_order_hash = {}
      order_products = order[1].split(';')
      order_products.each do |product|
        each_product = product.split(':')
        this_order_hash[each_product[0]] = each_product[1].to_f
      end
      all_products << this_order_hash
    end


    orders = []
    external_orders_file.each_with_index do |order, i|
      orders << Order.new(order[0].to_i, all_products[i], Customer.find(order[2].to_i), order[3])
    end

    return orders
  end

end