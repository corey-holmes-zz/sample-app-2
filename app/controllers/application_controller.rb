class ApplicationController < ActionController::Base  
  protect_from_forgery with: :exception

  require 'rest-client'

  # Update lines 7, 8, and 10. Do not edit anything else on this page.
  APIKEY_SHOPIFY    = '6afd799036d8295b2b0aebfa5XXXXXX'
  PASSWORD_SHOPIFY  = '2de39c052ee54332a03c3ed00XXXXXX'
  # If the Shopify URL is world-vision-canada.myshopify.com the SHOPNAME should be world-vision-canada
  SHOPNAME          = 'some-test-app'
 
  CYCLE    = 0.5

  @url = "https://#{APIKEY_SHOPIFY}:#{PASSWORD_SHOPIFY}@#{SHOPNAME}.myshopify.com/admin"
  ShopifyAPI::Base.site = @url
    
end
