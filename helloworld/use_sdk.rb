require 'amazon_pay'

# Your Amazon Pay keys are
# available in your Seller Central account
merchant_id = ENV.fetch('YOUR_MERCHANT_ID')
access_key = ENV.fetch('YOUR_ACCESS_KEY')
secret_key = ENV.fetch('YOUR_SECRET_KEY')

client = AmazonPay::Client.new(
  merchant_id,
  access_key,
  secret_key,
  sandbox: true
)