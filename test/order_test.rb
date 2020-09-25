require 'minitest/autorun'
require 'minitest/reporters'
require 'minitest/skip_dsl'

# require_relative '../lib/customer'
require_relative '../lib/order'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

describe "Order Wave 1" do
  let(:customer) do
    address = {
      street: "123 Main",
      city: "Seattle",
      state: "WA",
      zip: "98101"
    }
    Customer.new(123, "a@a.co", address)
  end

  describe "#initialize" do
    it "Takes an ID, collection of products, customer, and fulfillment_status" do
      id = 1337
      fulfillment_status = :shipped
      order = Order.new(id, {}, customer, fulfillment_status)

      expect(order).must_respond_to :id
      expect(order.id).must_equal id

      expect(order).must_respond_to :products
      expect(order.products.length).must_equal 0

      expect(order).must_respond_to :customer
      expect(order.customer).must_equal customer

      expect(order).must_respond_to :fulfillment_status
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Accepts all legal statuses" do
      valid_statuses = %i[pending paid processing shipped complete]

      valid_statuses.each do |fulfillment_status|
        order = Order.new(1, {}, customer, fulfillment_status)
        expect(order.fulfillment_status).must_equal fulfillment_status
      end
    end

    it "Uses pending if no fulfillment_status is supplied" do
      order = Order.new(1, {}, customer)
      expect(order.fulfillment_status).must_equal :pending
    end

    it "Raises an ArgumentError for bogus statuses" do
      bogus_statuses = [3, :bogus, 'pending', nil]
      bogus_statuses.each do |fulfillment_status|
        expect {
          Order.new(1, {}, customer, fulfillment_status)
        }.must_raise ArgumentError
      end
    end
  end

  describe "#total" do
    it "Returns the total from the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)

      expected_total = 5.36

      expect(order.total).must_equal expected_total
    end

    it "Returns a total of zero if there are no products" do
      order = Order.new(1337, {}, customer)

      expect(order.total).must_equal 0
    end
  end

  describe "#add_product" do
    it "Increases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Order.new(1337, products, customer)

      order.add_product("salad", 4.25)
      expected_count = before_count + 1
      expect(order.products.count).must_equal expected_count
    end

    it "Is added to the collection of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)

      order.add_product("sandwich", 4.25)
      expect(order.products.include?("sandwich")).must_equal true
    end

    it "Raises an ArgumentError if the product is already present" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.add_product("banana", 4.25)
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end

    it "Raises an ArgumentError for non-numerical string prices" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.add_product("salad", "four twenty-five")
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end


    it "Raises an ArgumentError for negative prices" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.add_product("salad", "-4.25")
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end

  describe "#remove_product" do
    it "Decreases the number of products" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      before_count = products.count
      order = Order.new(1337, products, customer)

      order.remove_product("cracker")
      expected_count = before_count - 1
      expect(order.products.count).must_equal expected_count
    end

    it "Removes product, case insensitive" do
      products = { "banana" => 1.99, "cracker" => 3.00 }
      order = Order.new(1337, products, customer)

      order.remove_product("crAcKER")
      expect(order.products.include?("cracker")).must_equal false
    end

    it "Raises an ArgumentError if the product is not in the order" do
      products = { "banana" => 1.99, "cracker" => 3.00 }

      order = Order.new(1337, products, customer)
      before_total = order.total

      expect {
        order.remove_product("sandwich")
      }.must_raise ArgumentError

      # The list of products should not have been modified
      expect(order.total).must_equal before_total
    end
  end

end

describe "Order Wave 2" do
  describe "Order.all" do
    it "Returns an array of all orders" do
      orders = Order.all(Order::DATA_FILEPATH)

      expect(orders.length).must_equal 100
      orders.each do |order|
        expect(order).must_be_instance_of Order
        expect(order.id).must_be_kind_of Integer
        expect(order.customer).must_be_instance_of Customer
        expect(order.products).must_be_kind_of Hash
        expect(order.fulfillment_status).must_be_kind_of Symbol
      end
    end

    it "Returns accurate information about the first order" do
      id = 1
      products = {
        "lobster" => 17.18,
        "annatto seed" => 58.38,
        "camomile" => 83.21
      }
      customer_id = 25
      fulfillment_status = :complete

      order = Order.all(Order::DATA_FILEPATH).first

      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end

    it "Returns accurate information about the last order" do
      id = 100
      products = {
        "amaranth" => 83.81,
        "smoked trout" => 70.6,
        "cheddar" => 5.63
      }
      customer_id = 20
      fulfillment_status = :pending

      order = Order.all(Order::DATA_FILEPATH).last

      # Check that all data was loaded as expected
      expect(order.id).must_equal id
      expect(order.products).must_equal products
      expect(order.customer).must_be_kind_of Customer
      expect(order.customer.id).must_equal customer_id
      expect(order.fulfillment_status).must_equal fulfillment_status
    end
  end

  describe "Order.find" do
    it "Can find the first order from the CSV" do
      first = Order.find(1)

      expect(first).must_be_kind_of Order
      expect(first.id).must_equal 1
    end

    it "Can find the last order from the CSV" do
      first = Order.find(100)

      expect(first).must_be_kind_of Order
      expect(first.id).must_equal 100
    end

    it "Returns nil for an order that doesn't exist" do
      expect(Order.find(101)).must_be_nil
    end
  end

  describe "Order.find_by_customer" do
    it "Can find the orders for the first customer id in the CSV" do
      first = Order.find_by_customer(25)

      expect(first).must_be_kind_of Array
      expect(first.length).must_equal 6
    end

    it "Can find the orders for the last customer id in the CSV" do
      last = Order.find_by_customer(20)

      expect(last).must_be_kind_of Array
      expect(last.length).must_equal 7
    end

    it "Can find the orders for the first customer id" do
      first = Order.find_by_customer(1)

      expect(first).must_be_kind_of Array
      expect(first.length).must_equal 1
    end

    it "Can find the orders for the last customer id" do
      last = Order.find_by_customer(35)

      expect(last).must_be_kind_of Array
      expect(last.length).must_equal 4
    end

    it "Returns an empty array for a customer that doesn't exist" do
      expect(Order.find_by_customer(36)).must_be_empty
    end
  end

end
