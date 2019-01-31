class CustomersController < ApplicationController
  before_action :validate_cpf, only: [:search]

  def search
    @customer = Client.find_by('cpf = ?', params[:cpf])
  end

  private

  def validate_cpf
    !CPF.valid?(params[:cpf]) && (redirect_to root_path, notice: 'CPF inválido')
  end
end
