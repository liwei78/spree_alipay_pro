module Spree
  class AlipayProController < StoreController
    skip_before_filter :verify_authenticity_token, only: [:notify]
    # ssl_allowed

    # 实时到账接口
    def pay
      @order = current_order || raise(ActiveRecord::RecordNotFound)
      @payment = @order.payments.create(amount: @order.amount, payment_method_id: params[:payment_method_id])
      if @payment
        @payment.started_processing!
        pay_url = payment_method.pay(options)
        redirect_to pay_url
      else
        redirect_to :root, notice: Spree.t(:no_payment_found)
      end
    end

    # 实时到账交易成功，返回 TRADE_SUCCESS
    def notify
      notify_params = params.except(*request.path_parameters.keys)
      logger.info notify_params
      if Alipay::Notify.verify?(notify_params) and ['TRADE_FINISHED', 'TRADE_SUCCESS'].include?(notify_params[:trade_status])
        out_trade_no = notify_params[:out_trade_no]
        payment = Spree::Payment.find_by(number: out_trade_no) || raise(ActiveRecord::RecordNotFound)
        unless payment.completed?
          payment.complete!
          payment.order.update_attributes(state: "complete")
          payment.order.finalize!
        end
        render text: "success"
      else
        render text: "fail"
      end
    end

    # 添加二维码
    def add_qrcode
      @order = current_order || raise(ActiveRecord::RecordNotFound)
      url = payment_method.manage_qrcode("add", options2)
      redirect_to url
    end

    # params with qrcode url
    def show_qrcode

    end

    def query_product

    end

    # 获取商品信息
    def query

    end

    private

    def payment_method
      @payment_method ||= Spree::PaymentMethod.find(params[:payment_method_id])
      @payment_method
    end

    def provider
      @payment_method.provider
    end

    def options
      {
        :out_trade_no      => @payment.number,
        :subject           => %{订单编号: #{@payment.number}},
        :logistics_type    => 'EMS',
        :logistics_fee     => @order.shipments.to_a.sum(&:cost),
        :logistics_payment => 'BUYER_PAY',
        :price             => @order.total,
        :quantity          => 1,
        :discount          => 0.0,
        :return_url        => spree.order_url(@order),
        :notify_url        => alipay_notify_url,
        :receive_name      => receive_name(@order),
        :receive_address   => receive_address(@order),
        :receive_zip       => @order.shipping_address.zipcode,
        :receive_phone     => @order.shipping_address.phone,
        :qr_pay_mode       => 2
      }
    end

    def options2
      {
        payment_method: @payment_method,
        order: @order,
        return_uri: alipay_show_qrcode_url,
        notify_uri: alipay_notify_url,
        query_url: alipay_query_product_url,
      }
    end

    def receive_name(order)
      [order.shipping_address.lastname, order.shipping_address.firstname].join(" ")
    ensure
      Spree.t("alipay_pro.invalid_name")
    end

    def receive_address(order)
      [order.shipping_address.country, order.shipping_address.state, order.shipping_address.city, order.shipping_address.address1, order.shipping_address.address2].join(" ")
    ensure
      Spree.t("alipay_pro.invalid_address")
    end
  end
end
