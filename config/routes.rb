Spree::Core::Engine.routes.draw do
  get "/alipay_pay" => "alipay_pro#pay", as: :alipay_pay
  post "/alipay_notify" => "alipay_pro#notify", as: :alipay_notify
  get "/alipay_add_qrcode" => "alipay_pro#add_qrcode", as: :alipay_add_qrcode
  get "/alipay_show_qrcode" => "alipay_pro#show_qrcode", as: :alipay_show_qrcode
  get "/alipay_query_product" => "alipay_pro#query_product", as: :alipay_query_product
end
