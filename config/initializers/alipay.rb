@client = Alipay::Client.new(
  url: ENV['ALIPAY_API'],
  app_id: ENV['APP_ID'],
  app_private_key: ENV['APP_PRIVATE_KEY'],
  alipay_public_key: ENV['ALIPAY_PUBLIC_KEY']
)
