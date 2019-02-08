require 'rails_helper'

feature 'Seller views products details on order register screen' do
  scenario 'Successfully' do
    user = create(:user)
    customer = create(:individual)
    product = create(:product)
    create(:product)
    login_as user

    visit root_path
    click_on 'Cadastrar Pedido'
    fill_in 'CPF', with: customer.cpf
    choose product.name
    click_on 'Cadastrar'

    expect(page).to have_content(product.name)
    expect(page).to have_content(product.price)
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
  end
end