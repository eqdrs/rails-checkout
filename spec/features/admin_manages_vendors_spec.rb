require 'rails_helper'

feature 'Admin manages vendors' do
  scenario 'successfully' do
    admin = create(:user)
    vendor = create(:vendor)
    login_as admin

    visit root_path
    click_on 'admin_manage_users'
    click_on "user-deactivate-#{vendor.id}"

    expect(page).to have_css(
      'div',
      text: I18n.t('users.messages.inactive_user', email: vendor.email)
    )
    expect(page).to have_content(I18n.t('users.manage.inactive'))
  end

  scenario 'fails when user is already inactive' do
    admin = create(:user)
    vendor = create(:vendor, status: :inactive)
    login_as admin

    visit root_path
    click_on 'admin_manage_users'

    expect(page).not_to have_link("user-deactivate-#{vendor.id}")
  end

  scenario 'and a vendor cant view manage vendors page' do
    vendor = create(:vendor)
    login_as vendor

    visit manage_users_path

    expect(current_path).to eq root_path
    expect(page).to have_content(I18n.t('users.messages.unauthorized'))
  end
end
