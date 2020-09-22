# Christabel Sebastian
# Last updated, Sept 22, 2020
# Ada C14
# Grocery Store: Customer Class

class Customer
  attr_reader :id
  attr_accessor :email, :delivery_address

  def initialize(id_num)
    @id = id_num
    @email = :unknown
    @delivery_address = { street: :unknown, city: :unknown, state: :unknown, country: :unknown }
  end

  def initialize(id_num, email)
    @id = id_num
    @email = email
    @delivery_address = { street: :unknown, city: :unknown, state: :unknown, country: :unknown }
  end

  def initialize(id_num, email, delivery_address_hash)
    @id = id_num
    @email = email
    @delivery_address = delivery_address_hash
  end



end