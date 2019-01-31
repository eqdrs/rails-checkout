
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

product = Product.create(name: 'host', price: 24.0)
customer = Customer.create(name: 'kamyla', address: 'rua X', cpf: '2344561290', phone: '1234534', email: 'email@email.com.br')

Order.create(product: product, status: 0, customer: customer)