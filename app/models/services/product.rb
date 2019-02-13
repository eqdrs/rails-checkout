class Services::Product
  def self.format_products(products)
    Array.new(products.size) { |i| Product.new(products[i]) }
  end

  def self.get_product(id)
    uri = URI("#{Rails.configuration.products_app['get_products']}/#{id}")
    response = JSON.parse(Net::HTTP.get(uri))
    response['product_id'] = response.delete('id')
    Product.new(response)
  end

  def self.all_products
    uri = URI(Rails.configuration.products_app['get_products'])
    products = JSON.parse(Net::HTTP.get(uri))
    format_products(products)
  end
end
