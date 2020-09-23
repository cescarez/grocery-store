# Christabel Sebastian
# Ada C14
# Grocery Store: Order Class
# sources: https://stackoverflow.com/questions/336024/calling-a-class-method-within-a-class

class Order
  VALID_STATUSES = [:pending, :paid, :processing, :shipped, :complete]
  TAX_RATE = 0.075

  attr_reader :id, :products, :fulfillment_status, :customer

  def initialize(id_num, products, customer_object,fulfillment_status = VALID_STATUSES[0])
    @id = id_num
    @customer = customer_object
    @products = (products && !products.empty?) ? products : {}
    @fulfillment_status = check_fulfillment_status(fulfillment_status)
  end

  def check_fulfillment_status(current_status)
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

  def self.all
    external_orders_file = CSV.read('data/orders.csv').map { |row| row.to_a }

    all_products = get_all_products(external_orders_file)

    orders = []
    external_orders_file.each_with_index do |order, i|
      orders << Order.new(order[0].to_i, all_products[i], Customer.find(order[2].to_i), order[3].to_sym)
    end

    return orders
  end

  def self.find(id)
    return all.find { |order| order.id == id }
  end

  def self.find_by_customer(customer_id)
    return all.filter { |order| order.customer.id == customer_id }
  end

  private

  def self.get_all_products(two_d_array)
    all_products = two_d_array.map do |order|
      order_products = order[1].split(';')
      this_order = order_products.each_with_object({}) do |product, hash|
        each_product = product.split(':')
        hash[each_product[0].downcase] = each_product[1].to_f
      end
      this_order
    end

    return all_products
  end

end