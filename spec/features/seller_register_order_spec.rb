require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully' do
    customer = create(:client)
    product = create(:product)

    visit root_path
    click_on 'Cadastrar Pedido'
    fill_in 'CPF', with: customer.cpf
    select product.name, from: 'Produtos'
    click_on 'Cadastrar'

    expect(page).to have_content(product.name)
    expect(page).to have_content(product.price)
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
  end

  scenario 'and must fill in all fields' do
    create(:product)

    visit new_order_path
    fill_in 'CPF', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end

  scenario 'and customer must exist' do
    create(:product)

    visit new_order_path
    fill_in 'CPF', with: '12345678910'
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end
end
