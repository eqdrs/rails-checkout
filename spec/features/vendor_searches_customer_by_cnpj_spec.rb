require 'rails_helper'

feature 'Vendor searches for a customer by cnpj' do
  scenario 'successfully' do
    vendor = create(:user)
    customer = create(:company, cnpj: '17298092000130')
    login_as(vendor, scope: :user)

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CNPJ', with: '17.298.092/0001-30'
    within('form#company') do
      click_on 'Buscar'
    end

    expect(current_path).to eq company_path(customer)
    expect(page).to have_content customer.company_name
    expect(page).to have_content customer.email
    expect(page).to have_content customer.formatted_cnpj
    expect(page).to have_content customer.phone
    expect(page).to have_content customer.contact
    expect(page).to have_content customer.address
  end

  scenario 'and customer doesn\'t exist' do
    vendor = create(:user)
    login_as(vendor, scope: :user)

    visit root_path
    click_on 'Pesquisar cliente'
    fill_in 'Por CNPJ', with: '17.298.092/0001-30'
    within('form#company') do
      click_on 'Buscar'
    end

    expect(page).to have_content I18n.t('companies.search.not_found')
  end
end
