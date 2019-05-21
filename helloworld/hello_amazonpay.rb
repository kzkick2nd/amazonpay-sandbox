require 'amazon_pay'

# Your Amazon Pay keys are
# available in your Seller Central account
merchant_id = 'YOUR_MERCHANT_ID'
access_key = 'YOUR_ACCESS_KEY'
secret_key = 'YOUR_SECRET_KEY'

client = AmazonPay::Client.new(
  merchant_id,
  access_key,
  secret_key,
  sandbox: true
)