
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

product = Product.create(name: 'Host', price: 24.0)
other_product = Product.create(name: 'Host2', price: 30.0)
Product.create(name: 'Host3', price: 45.0)

vendor = User.create!(email: 'vendor@vendas.com', password: '12345678', role: :vendor)
user = User.create!(email: 'admin@vendas.com', password: '12345678', role: :admin)

customer = Individual.create!(name: 'Kamyla Aragão', address: 'rua X', cpf: '28813510420', phone: '(11) 9345-2345', email: 'kamyla@email.com.br', user: vendor)

Order.create!(product: product, status: :open, customer: customer, user: vendor)
Order.create!(product: other_product, status: :approved, sent_to_client_app: :sent, customer: customer, user: vendor)
