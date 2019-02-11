require 'rails_helper'

feature 'Seller views products details on order register screen' do
  scenario 'Successfully' do
    stub_request(:get, 'http://localhost:3000/api/v1/products')
      .to_return(body: File.read('spec/support/all_products.json').to_s,
                 status: 200)

    user = create(:user)
    create(:product)
    login_as user
    visit root_path
    click_on 'Cadastrar Pedido'

    expect(page).to have_content('Email Marketing')
    expect(page).to have_content('Descrição: Email marketing para criação '\
                                 'de promoções')
    expect(page).to have_content('Categoria: Email')
    expect(page).to have_content('Criador de Sites')
    expect(page).to have_content('Descrição: Criar sites de maneira fácil com '\
                                 'o criador de sites')
    expect(page).to have_content('Categoria: Sites')
    expect(page).to have_content('Email')
    expect(page).to have_content('Descrição: Email profissional')
    expect(page).to have_content('Categoria: Email')
  end
end
