#encoding: utf-8
module Spree
  CheckoutController.class_eval do

    before_action :check_alipay, only: :update

    private

    def check_alipay
      return if current_order.total == 0
      return unless params[:state] == 'payment'
      return unless params[:order][:payments_attributes]
      return unless payment_method_alipay_valid?
      redirect_to alipay_pay_path(payment_method_id: params[:order][:payments_attributes].first[:payment_method_id])
    end

    def payment_method_alipay_valid?
      payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      return false unless (payment_method and payment_method.type == "Spree::Gateway::AlipayDualPay")
      return true
    end
  end
end
