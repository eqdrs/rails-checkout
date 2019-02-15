class ProductsApi
  def self.format_products(products)
    Array.new(products.size) do |i|
      products[i].delete('icon')
      Product.new(products[i])
    end
  end

  def self.get_product(id)
    uri = URI("#{Rails.configuration.products_app['get_products']}/#{id}")
    response = JSON.parse(Net::HTTP.get(uri))
    response['product_id'] = response.delete('id')
    response.delete('icon')
    Product.new(response)
  end

  def self.all_products
    uri = URI(Rails.configuration.products_app['get_products'])
    products = JSON.parse(Net::HTTP.get(uri))
    format_products(products)
  end

  def self.format_plans(plans)
    array = []
    plans.each { |p| array << Product.new(p) }
    array
  end

  def self.get_plan(product_id, plan_id)
    uri = URI("#{Rails.configuration.products_app['get_products']}"\
              "/#{product_id}/plans/#{plan_id}")
    JSON.parse(Net::HTTP.get(uri))
  end

  def self.all_plans(id)
    uri = URI("#{Rails.configuration.products_app['get_products']}/#{id}/plans")
    plans = JSON.parse(Net::HTTP.get(uri))
    format_plans(plans)
  end
end
