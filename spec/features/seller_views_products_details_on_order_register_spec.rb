require 'rails_helper'

feature 'Seller views products details on order register screen' do
  scenario 'Successfully' do
    user = create(:user)
    customer = create(:individual)
    product = create(:product)

    login_as user
    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CPF', with: customer.cpf
    within('form#individual') do
      click_on 'Buscar'
    end
    click_on 'Cadastrar pedido'
    choose product.name
    click_on 'Cadastrar Pedido'

    expect(page).to have_content(product.name)
    expect(page).to have_content('R$ 50,0')
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
  end
end
