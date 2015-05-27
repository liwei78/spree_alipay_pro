Spree::Core::Engine.routes.draw do
  get "/alipay_pay" => "alipay_pro#pay", as: :alipay_pay
  post "/alipay_notify" => "alipay_pro#notify", as: :alipay_notify
end
