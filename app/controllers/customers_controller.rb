class CustomersController < ApplicationController
  before_action :authenticate_user!

  def search; end
end
