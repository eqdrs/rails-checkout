require 'rails_helper'

feature 'Inactive vendor fails to log in' do
  scenario 'successfully' do
    user = create(:vendor, status: :inactive)

    visit new_user_session_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Entrar'

    expect(page).to have_content(I18n.t('users.messages.inactive_user',
                                        email: user.email))
  end
end
