class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart
  belongs_to :order

  def total_price
    product.price * quantity
  end

  def delete_line_item?
		if(quantity <= 1) 
			return true
		else
			return false
		end 
  end

  def decrement_quantity! 
  	decrement! :quantity
  end  
end
