class HomeController < ApplicationController
  def home
    @orders = Order.all
  end
end
