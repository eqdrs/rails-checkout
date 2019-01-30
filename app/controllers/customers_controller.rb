class CustomersController < ApplicationController
  def search
    @customer = Client.find_by('cpf = ?', params[:cpf])
  end
end