require 'rails_helper'

feature 'Admin register user' do
  scenario 'successfully' do
    visit root_path
    click_on 'Cadastrar usuário'
    fill_in 'Email', with: 'teste@vendas.com'
    fill_in 'Senha', with: '123456'
    select 'Vendedor', from: 'Função'
    click_on 'Cadastrar'

    expect(page).to have_content('Usuário cadastrado com sucesso!')
    expect(current_path).to eq user_path(user)
    expect(page).to have_css('h2', text: 'Email')
    expect(page).to have_css('p', text: 'teste@vendas.com')
    expect(page).to have_css('h2', text: 'Função')
    expect(page).to have_css('p', text: 'Vendedor')
  end
end