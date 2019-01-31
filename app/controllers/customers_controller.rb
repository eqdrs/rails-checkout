class CustomersController < ApplicationController
  before_action :validate_cpf, only: [:search]

  def search
    @customer = Customer.find_by('cpf = ?', params[:cpf])
  end
  
  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      redirect_to @customer
    else 
      render :new
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  private

  def validate_cpf
    !CPF.valid?(params[:cpf]) && (redirect_to root_path, notice: 'CPF inválido')
  end

  def customer_params
    params.require(:customer).permit(:name, :address, :email,
                                   :cpf, :phone)
  end
end
