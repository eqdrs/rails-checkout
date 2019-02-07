class CustomersController < ApplicationController
  before_action :authenticate_user!

  def search; end

  def index
    if current_user.admin?
      @individuals = Individual.all
      @companies = Company.all
    else
      @individuals = Individual.where(user: current_user)
      @companies = Company.where(user: current_user)
    end
  end
end
