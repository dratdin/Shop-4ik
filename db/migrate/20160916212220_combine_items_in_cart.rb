class CombineItemsInCart < ActiveRecord::Migration
  def change
  end

  def up
  	Cart.all.each do |cart|
  		# подсчет количества каждого товара в корзине 
  		sums = cart.line_items.group(:product_id).sum(:quantity)

  		sums.each do |product_id, quantity|
  			if quantity > 1
  				# удаление отдельных записей
  				cart.line_items.where(product_id: product_id).delete_all

  				# замена одной записью
  				item = cart.line_items.build(product_id: product_id)
  				item.quantity = quantity
  				item.save!
  			end
  		end
  	end
  end

  def down
    # Разбиение записей с quantity>1 на несколько записей
    LineItem.where("quantity>1").each do |line_item|
      # добавление уникального товара
      line_item.quantity.items do 
        LineItem.create cart_id: line_item.cart_id,
          product_id: line_item.product_id, quantity: 1
      end
    end
  end
end
