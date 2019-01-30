require 'rails_helper'

feature 'Vendor searches for a customer by cpf' do
  scenario 'successfully' do
    vendor = create(:user)
    customer = create(:client, cpf: '36746239861')
    login_as(vendor, scope: :user)

    visit root_path
    fill_in 'Buscar cliente por CPF', with: '36746239861'
    click_on 'Buscar'

    expect(page).to have_content "Nome: #{customer.name}"
    expect(page).to have_content "E-mail: #{customer.email}"
    expect(page).to have_content "CPF: #{customer.cpf}"
    expect(page).to have_content "Tel: #{customer.phone}"
  end

  scenario 'and customer doesn\'t exist' do
    vendor = create(:user)

    login_as(vendor, scope: :user)
    visit root_path
    fill_in 'Buscar cliente por CPF', with: '36746239861'
    click_on 'Buscar'

    expect(page).to have_content 'Nenhum usuário encontrado.'
  end

  scenario 'and cpf length must be valid' do
    vendor = create(:user)
    create(:client, cpf: '36746239861')
    login_as(vendor, scope: :user)

    visit root_path
    fill_in 'Buscar cliente por CPF', with: '36746239'
    click_on 'Buscar'

    expect(page).to have_content 'CPF inválido.'
  end
end