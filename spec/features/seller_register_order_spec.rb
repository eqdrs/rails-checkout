require 'rails_helper'

feature 'Seller register order' do
  scenario 'Successfully' do
    user = create(:user)
    customer = create(:individual)
    product = create(:product)
    mail_spy = spy(CustomerMailer)
    stub_const('CustomerMailer', mail_spy)
    login_as user

    visit root_path
    click_on 'Cadastrar Pedido'
    fill_in 'CPF', with: customer.cpf
    select product.name, from: 'Produto'
    click_on 'Cadastrar'

    expect(page).to have_content(product.name)
    expect(page).to have_content(product.price)
    expect(page).to have_content(customer.name)
    expect(page).to have_content('Em Aberto')
    expect(mail_spy).to have_received(:order_summary)
  end

  scenario 'and must fill in all fields' do
    user = create(:user)
    create(:product)
    login_as user

    visit new_order_path
    fill_in 'CPF', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end

  scenario 'and customer must exist' do
    user = create(:user)
    create(:product)
    login_as user

    visit new_order_path
    fill_in 'CPF', with: '12345678910'
    click_on 'Cadastrar'

    expect(page).to have_content(I18n.t('errors.messages.required'))
  end
end
