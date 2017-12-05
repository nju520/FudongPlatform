## 支付宝支付功能测试

### gem 使用
```ruby
gem 'alipay', '~> 0.15.0'
gem 'dotenv-rails', '~> 2.2', '>= 2.2.1'
```

### .ENV
.ENV文件中保存各种密钥和网关地址

### config/initializers/alipay.rb
创建一个支付宝客户端

```ruby
$alipay = Alipay::Client.new(
  url: ENV['ALIPAY_API'],
  app_id: ENV['APP_ID'],
  app_private_key: ENV['APP_PRIVATE_KEY'],
  alipay_public_key: ENV['ALIPAY_PUBLIC_KEY']
)

```

### config/application.rb
设置回调地址

```ruby
# ENV['ALIPAY_RETURN_URL'] = 'http://localhost:3000/payments/pay_return'
# ENV['ALIPAY_NOTIFY_URL'] = 'http://localhost:3000/payments/pay_notify'
ENV['ALIPAY_RETURN_URL'] = 'https://risewinter/payments/pay_return'
ENV['ALIPAY_NOTIFY_URL'] = 'https:///risewinter/payments/pay_notify'

```

### 运行

* rails server
* lt --port 
