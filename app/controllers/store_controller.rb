class StoreController < ApplicationController
  include CurrentCart
  before_action :set_cart
  def index
  	@products = Product.order(:title)
  	@time = Time.now
  	if session[:counter].nil?
  		session[:counter] = 0
  	else 
  		session[:counter] += 1
  	end
  end
end
