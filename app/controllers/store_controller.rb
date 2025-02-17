class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
    @products = Product.order(:title)
  end
  def reset_count
    @visits = 0
  end

  private

  def set_visit_count
    session[:visits] ||= 0
    session[:visits] += 1
    @visits = session[:visits]
  end
end
