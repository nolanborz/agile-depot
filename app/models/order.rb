class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :payment_type

  validates :name, :address, :email, presence: true
  validates :payment_type_id, presence: true

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  # Helper method to get pay type name
  def pay_type
    payment_type&.name
  end
end
