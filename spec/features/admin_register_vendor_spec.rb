require 'rails_helper'

feature 'Admin register vendor' do
  scenario 'successfully' do
    admin = create(:user, role: :admin)
    mail_spy = spy(UserMailer)
    stub_const('UserMailer', mail_spy)

    login_as(admin, scope: :user)
    visit root_path
    click_on 'Cadastrar usuário'
    fill_in 'Email', with: 'teste@vendas.com'
    fill_in 'CPF', with: '123456'
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content('Usuário cadastrado com sucesso!')
    expect(current_path).to eq root_path
    expect(User.last.email).to eq 'teste@vendas.com'
    expect(mail_spy).to have_received(:registered_user)
  end

  scenario 'and must fill in required fields' do
    admin = create(:user, role: :admin)

    login_as(admin, scope: :user)
    visit root_path
    click_on 'Cadastrar usuário'
    fill_in 'Email', with: ''
    fill_in 'CPF', with: ''
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content(
      'Você deve informar todos os campos obrigatórios'
    )
    expect(current_path).to eq register_path
  end

  scenario 'and only admin can register user' do
    vendor = create(:user, role: :vendor)

    login_as(vendor, scope: :user)
    visit root_path

    expect(page).not_to have_link 'Cadastrar usuário'
  end

  scenario 'and vendor can not access user register path' do
    vendor = create(:user, role: :vendor)

    login_as(vendor, scope: :user)
    visit register_path

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem permissão para realizar esta '\
                                 'ação'
  end
end
