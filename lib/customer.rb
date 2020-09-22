# Christabel Sebastian
# Last updated, Sept 22, 2020
# Ada C14
# Grocery Store: Customer Class

class Customer
  attr_reader :id
  attr_accessor :email, :address

  def initialize(id_num, email, delivery_address_hash)
    @id = id_num
    @email = email
    @address = delivery_address_hash
  end



end