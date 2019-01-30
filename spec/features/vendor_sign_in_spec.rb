require 'rails_helper'

feature 'Vendor sign in' do
  scenario 'successfully' do
    vendor = create(:user, role: :vendor)

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: vendor.email
    fill_in 'Senha', with: '12345678'
    click_on 'Entrar'

    expect(current_path).to eq root_path
    expect(page).to_not have_link 'Entrar'
    expect(page).to have_link 'Sair'
    expect(page).to have_content "Olá, #{vendor.email}"
  end
end