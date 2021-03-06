require 'rails_helper'

feature 'User views customers list' do
  scenario 'sucessfully' do
    user = create(:user, role: :admin)
    individual = create(:individual, email: 'individual@vendas.com',
                                     cpf: '01011888033')
    company = create(:company, email: 'company@vendas.com',
                               cnpj: '71089986000166')
    login_as user
    visit root_path
    click_on 'Visualizar Clientes'

    expect(current_path).to eq customers_path
    expect(page).to have_content(individual.name)
    expect(page).to have_content(individual.cpf)
    expect(page).to have_content(company.company_name)
    expect(page).to have_content(company.cnpj)
  end

  scenario 'Seller should view only his clients' do
    user = create(:user, role: :vendor)
    other_user = create(:user, role: :vendor)
    customer = create(:individual, user: user, name: 'Fulano')
    other_customer = create(:individual, user: other_user, name: 'Beltrano')
    login_as user
    visit root_path
    click_on 'Visualizar Clientes'

    expect(current_path).to eq customers_path
    expect(page).to have_content(customer.name)
    expect(page).not_to have_content(other_customer.name)
  end
end
