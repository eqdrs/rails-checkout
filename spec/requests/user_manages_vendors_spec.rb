require 'rails_helper'

RSpec.describe 'Direct requests to deactivate vendors' do
  it 'successfully if current user is an admin' do
    admin = create(:user)
    login_as admin
    vendor = create(:vendor)

    post "/users/#{vendor.id}/deactivate"
    vendor.reload
    follow_redirect!

    expect(response.body).to include(I18n.t('users.messages.inactive_user',
                                            email: vendor.email))
    expect(vendor).not_to be_active
  end

  it 'should fail when user is not logged in' do
    user = create(:vendor)
    post "/users/#{user.id}/deactivate"
    user.reload

    expect(response).to redirect_to new_user_session_path
    expect(user).to be_active
  end

  it 'should fail when user is a vendor' do
    user = create(:vendor)
    not_admin = create(:vendor)

    login_as not_admin

    post "/users/#{user.id}/deactivate"
    user.reload

    expect(response).to redirect_to root_path
    expect(user).to be_active
  end
end
