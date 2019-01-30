require 'rails_helper'

feature 'Admin approves order' do
  scenario 'Successfully' do
    skip
    order = create(:order)
    visit root_path
    click_on 'Pedidos'
    click_on order.name
    click_on 'Aprovar'

    expect(current_path).to eq(order_path(order))
    expect(page).to have_content('Aprovado')
    expect(page).not_to have_link('Aprovar')
  end
end
