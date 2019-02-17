
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

product = Product.create(name: 'Host', description: 'Produto host', category: 'Hosts',
                         product_id: 2, plan_name: 'Básico', plan_description: 'Plano básico',
                         price: 24.0)

vendor = User.create!(email: 'vendor@vendas.com', password: '12345678', role: :vendor)
user = User.create!(email: 'admin@vendas.com', password: '12345678', role: :admin)

customer = Individual.create!(name: 'Kamyla Aragão', address: 'Rua Wallace Almeida', cpf: '28813510420', phone: '(11) 9345-2345', email: 'kamyla@email.com.br', user: vendor)
other_customer = Individual.create!(name: 'Everton Quadros', address: 'Alameda Jaú', cpf: '39565551041', phone: '(11) 9085-1123', email: 'everton@email.com.br', user: vendor)

Order.create!(product: product, status: :open, customer: customer, user: vendor)
not_sent_order = Order.create!(product: product, status: :approved, sent_to_client_app: :not_sent, customer: other_customer, user: vendor)

OrderApproval.create!(user: user, order: not_sent_order)

