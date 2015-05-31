#encoding: utf-8
module Spree
  CheckoutController.class_eval do

    before_action :check_alipay, only: :update

    private

    def check_alipay
      return if current_order.total == 0
      return unless params[:state] == 'payment'
      return unless params[:order][:payments_attributes]
      payment_method = Spree::PaymentMethod.find(params[:order][:payments_attributes].first[:payment_method_id])
      if payment_method.present?
        if payment_method.method_type == "alipay_qrcode"
          redirect_to alipay_add_qrcode_path(payment_method_id: params[:order][:payments_attributes].first[:payment_method_id])
        else
          redirect_to alipay_pay_path(payment_method_id: params[:order][:payments_attributes].first[:payment_method_id])
        end
      else
        return
      end
    end

  end
end
