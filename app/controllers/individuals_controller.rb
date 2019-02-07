class IndividualsController < ApplicationController
  before_action :authenticate_user!

  def new
    @individual = Individual.new
  end

  def create
    @individual = Individual.new individual_params
    if @individual.save
      redirect_to @individual, notice: 'Cliente cadastrado com sucesso'
    else
      render :new
    end
  end

  def show
    @individual = Individual.find(params[:id])
  end

  def search
    @individual = Individual.find_by(cpf: CPF.new(params[:cpf]).stripped)
    if !@individual.nil?
      redirect_to @individual
    else
      redirect_to(search_customer_path,
                  alert: I18n.t('individuals.search.not_found'))
    end
  end

  private

  def individual_params
    params.require(:individual).permit(:name, :address, :email,
                                       :cpf, :phone)
  end
end
