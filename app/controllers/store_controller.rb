class StoreController < ApplicationController
  before_action :set_visit_count
  def index
    @products = Product.order(:title)
    @time = Time.new
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
