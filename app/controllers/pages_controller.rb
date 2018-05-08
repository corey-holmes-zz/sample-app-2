class PagesController < ApplicationController  
  require 'json'

  def index   
  end

  def process_products
    # Products with this unique identifier in their *handle* will be deleted if found.
    # This is case sensitive
    # This does not effect products that are of type "Gift Card"
    product_identifier = "-"

    products           = ShopifyAPI::Product.all
    products_count     = ShopifyAPI::Product.count
    number_of_pages    = (products_count / 250.0).ceil

    puts '------------------------'
    puts "Total products: " + products_count.to_s
    puts "Number of pages to process: " + number_of_pages.to_s
    puts '------------------------'

    sleep 3

    start_time = Time.now
    
    1.upto(number_of_pages) do |page|
      unless page == 1
        stop_time = Time.now
        processing_duration = stop_time - start_time
        wait_time = (CYCLE - processing_duration).ceil
        sleep wait_time if wait_time > 0
        start_time = Time.now
      end

      puts '-----------------------'
      puts "Processing #{page}/#{number_of_pages}"
      puts '-----------------------'

      products = ShopifyAPI::Product.find( :all, :params => { :limit => 250, :page => page } )
      
      # Loop through all the products
      products.each do |product|
        # Delete the product if it is NOT a Gift Card AND the Product Handle contains the product_identifier
        if product.handle.include? product_identifier and product.product_type != "Gift Card"
          Puts "[Deleted] Product ID: #{product.id} | Handle:  #{product.handle}"
          product.destroy
        else
          # Loop through all the product variants and update requires_shipping to FALSE if it set to TRUE
          product.variants.each do |variant|
            if variant.requires_shipping == true
              variant.requires_shipping = false
              variant.save
              puts "[Updated Shipping] Variant ID: #{variant.id}"
            end
          end
        end
      end    

    end
  end

end
