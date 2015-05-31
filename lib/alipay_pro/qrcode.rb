require 'alipay'

# Provider
module AlipayPro
  module Qrcode

    class << self
      ADD_QRCODE_REQUIRED_PARAMS = %w( out_trade_no subject logistics_type logistics_fee logistics_payment price quantity )
      # alipayescow
      def manage_qrcode(method, options = {})

        qrcode_params = {
          'service'        => 'alipay.mobile.qrcode.manage',
          'partner'        => Alipay.pid,
          '_input_charset' => 'utf-8',
          'timestamp'      => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
          'method'         => method,
          'biz_type'       => 10,
          'biz_data'       => biz_data(options)
        }

        ::Alipay::Service.request_uri(qrcode_params).to_s
      end

      private

      def biz_data(options)
        {
          trade_type: 2,
          need_address: "T",
          return_uri: options[:return_uri],
          notify_uri: options[:notify_uri],
          query_url: options[:query_url],
          goods_info: goods_info(options)
        }.to_json
      end

      # options: payment_method, order.
      def goods_info(options)
        {
          id: 1111,
          name: "Test",
          price: 10000.00,
          inventory: 999,
        }.to_json
      end

      # options: payment_method, order.
      def ext_info(options)
        {
          single_limit: 10,
          user_limit: 99,
        }.to_json
      end
    end
  end
end
