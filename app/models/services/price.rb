class Services::Price
  attr_accessor :name, :value

  def self.all(order)
    response = request(plan_id: order.product.plan_id,
                       product_id: order.product_id)

    Array.new(response.length) do |i|
      new(name: response[i]['period'],
          value: response[i]['value'])
    end
  end

  def self.request(plan_id:, product_id:)
    uri = URI("#{Rails.configuration.products_app['get_products']}/"\
              "#{product_id}/plans/#{plan_id}/prices")
    JSON.parse(Net::HTTP.get(uri))
  end

  def initialize(name:, value:)
    @name = name
    @value = value
  end
end
