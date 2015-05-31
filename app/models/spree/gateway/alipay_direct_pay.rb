require 'alipay'
module Spree
  class Gateway::AlipayDirectPay < Gateway
    preference :pid, :string
    preference :key, :string

    def supports?(source)
      true
    end

    def auto_capture?
      true
    end

    def source_required?
      false
    end

    def method_type
      'alipay_direct_pay'
    end

    def provider_class
      ::Alipay::Service
    end

    def provider
      setup_alipay
      ::Alipay::Service
    end

    def purchase(money, source, gateway_options)
      nil
    end

    # 购买
    def pay(options={})
      provider.create_direct_pay_by_user_url(options)
    end

    # 退款
    def refund

    end

    private

    def setup_alipay
      Alipay.pid = preferred_pid
      Alipay.key = preferred_key
    end
  end
end
