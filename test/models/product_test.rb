require 'test_helper'

class ProductTest < ActiveSupport::TestCase
   fixtures :products

   test "Product attributes must not be empty" do
     product = Product.new
     assert product.invalid?
     assert product.errors[:title].any?
     assert product.errors[:description].any?
     assert product.errors[:price].any?
     assert product.errors[:image_url].any?
   end

   test "Product price must be positive" do
   	product = Product.new(title: "O great new world", description: "Zaebis!!!",
   		image_url: "322.jpg")
   	product.price = -1
   	assert product.invalid?
   	assert_equal ["must be greater than or equal to 0.01"],
   		product.errors[:price]
   	product.price = 0

   	assert product.invalid?
   	assert_equal ["must be greater than or equal to 0.01"],
   		product.errors[:price]
   	product.price = 1
   	assert product.valid?
   end 

   test "Product is not valid without a unique title - i18n" do
   	product = Product.new(title: products(:ruby).title,
   		description: "yyy",
   		price: 2.8,
   		image_url: "ruby.jpg")

   	assert product.invalid?

   	assert_equal [I18n.translate('activerecord.errors.messages.taken')],
   		product.errors[:title]
   end
end
