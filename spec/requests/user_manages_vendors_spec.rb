require 'rails_helper'

RSpec.describe 'Direct requests to deactivate vendors' do
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
