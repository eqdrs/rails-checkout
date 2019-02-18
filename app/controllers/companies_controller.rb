class CompaniesController < ApplicationController
  before_action :authenticate_user!

  def new
    @company = Company.new
  end

  def create
    @company = Company.new company_params
    @company.user = current_user
    if @company.save
      redirect_to @company, notice: I18n.t('companies.create.success')
    else
      render :new
    end
  end

  def show
    @customer = Company.find(params[:id])
  end

  def search
    @company = Company.find_by(cnpj: CNPJ.new(params[:cnpj]).stripped)
    if @company.nil?
      redirect_to(search_customer_path,
                  alert: I18n.t('companies.search.not_found'))
    else
      redirect_to @company
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :company_name, :cnpj, :contact,
                                    :address, :phone, :email)
  end
end
