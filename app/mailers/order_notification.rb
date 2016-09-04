class OrderNotification < ApplicationMailer
  default from: "Mr. Mihan <mihan-shoppy.com>"

  def received(order)
    @order = order
    @ps = "Нужно читать хотябы пол часика схемотехнику перед сном, иначе удачи не видать"
    mail to: order.email, subject: "Подтверждение заказа"
  end

  def shipped(order)
    @order = order
    @ps = "Нужно читать хотябы пол часика схемотехнику перед сном, иначе удачи не видать"
    mail to: order.email, subject: "Подтверждение заказа"
  end
end
