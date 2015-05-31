require 'alipay'
require 'alipay_pro/qrcode'

module Spree
  class Gateway::AlipayQrcode < Gateway

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
      'alipay_qrcode'
    end

    def provider_class
      ::AlipayPro::Qrcode
    end

    def provider
      setup_alipay
      ::AlipayPro::Qrcode
    end

    def purchase(money, source, gateway_options)
      nil
    end

    def manage_qrcode(method, options={})
      provider.manage_qrcode(method, options)
    end

    private

    def setup_alipay
      Alipay.pid = preferred_pid
      Alipay.key = preferred_key
    end
  end
end
