Spree::Core::Engine.routes.draw do
  get "/alipay_pay" => "alipay#pay", as: :alipay_pay
  post "/alipay_notify" => "alipay#notify", as: :alipay_notify
end
