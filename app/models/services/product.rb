class Services::Product
  def self.format_products(products)
    array = []
    products.each { |r| array << Product.new(r) }
    array
  end

  def self.get_product(id)
    uri = URI("#{Rails.configuration.products_app['get_products']}/#{id}")
    response = JSON.parse(Net::HTTP.get(uri))
    Product.new(response)
  end

  def self.all_products
    uri = URI(Rails.configuration.products_app['get_products'])
    products = JSON.parse(Net::HTTP.get(uri))
    format_products(products)
  end
end
