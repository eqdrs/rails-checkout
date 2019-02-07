require 'rails_helper'

feature 'Vendor searches for a customer by cpf' do
  scenario 'successfully' do
    vendor = create(:user)
    customer = create(:individual, cpf: '28813510420')
    login_as(vendor, scope: :user)

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CPF', with: '288.135.104-20'
    within('form#individual') do
      click_on 'Buscar'
    end

    expect(current_path).to eq individual_path(customer)
    expect(page).to have_content customer.name
    expect(page).to have_content customer.email
    expect(page).to have_content customer.formatted_cpf
    expect(page).to have_content customer.phone
  end

  scenario 'and customer doesn\'t exist' do
    vendor = create(:user)
    login_as(vendor, scope: :user)

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CPF', with: '288.135.104-20'
    within('form#individual') do
      click_on 'Buscar'
    end

    expect(page).to have_content I18n.t('individuals.search.not_found')
  end
end
