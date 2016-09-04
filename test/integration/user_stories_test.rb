require 'test_helper'

# Комплексный тест
class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products

  test "buying a product" do
    # Очищаем нужные нам таблицы
    LineItem.delete_all
    Order.delete_all
    # Будем работать только с одним продуктом
    ruby_book = products(:ruby)

    # Заходим на сайт
    get '/'
    assert_response :success
    assert_template "index"

    # Делаем пост запрос на добавление продукта ruby_book в список товарных позиций
    xml_http_request :post, '/line_items', product_id: ruby_book.id
    assert_response :success

    # Смотрим, оторбразилась ли товарная позиция в корзине
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product

    # Создаем новый заказ
    get "/orders/new"
    assert_response :success
    assert_template "new"

    # Заполненяем форму заказа
    post_via_redirect "/orders",
                order: { name:        "Dave Thomas",
                         address:     "123 The Street",
                         email:    "mrtard47@gmail.com",
                         pay_type:   "Check" }
    assert_response :success
    assert_template "index"

    # Проверяем удалилась ли товарная позиция после оформления заказа
    cart = Cart.find(session[:cart_id])
    assert_equal 0, cart.line_items.size

    # Смотрим появился ли заказ в таблице
    orders = Order.all
    assert_equal 1, orders.size
    order = orders[0]

    # Проверяем содержимое этого заказа и сравниваем с тем что мы заполняли прежде
    assert_equal "Dave Thomas", order.name
    assert_equal "123 The Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type
    assert_equal 1, order.line_items.size
    # Сравниваем дату отправки почты подтверждения
    assert_equal Date.current, order.ship_date
    line_item = order.line_items[0]
    assert_equal ruby_book, line_item.product
  end
end
