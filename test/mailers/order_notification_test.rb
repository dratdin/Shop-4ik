require 'test_helper'

class OrderNotificationTest < ActionMailer::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "received" do
    mail = OrderNotification.received(orders(:one))
    assert_equal ["mihanshoppy@gmail.com"], mail.from
  end

  test "shipped" do
    mail = OrderNotification.received(orders(:one))
    assert_equal ["mihanshoppy@gmail.com"], mail.from
  end
end
