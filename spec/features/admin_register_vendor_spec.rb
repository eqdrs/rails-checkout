require 'rails_helper'

feature 'Admin register vendor' do
  scenario 'successfully' do
    admin = create(:user, role: :admin)
    mail_spy = spy(UserMailer)
    stub_const('UserMailer', mail_spy)

    login_as(admin, scope: :user)
    visit root_path
    click_on 'Cadastrar usuário'
    save_page
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
    save_page
    fill_in 'Email', with: ''
    fill_in 'CPF', with: ''
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content(
      'Você deve informar todos os campos obrigatórios'
    )
    expect(current_path).to eq register_path
  end
end
