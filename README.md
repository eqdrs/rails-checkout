# README

* API Documentation
  *GET all orders
    
    The api expect to receive a GET in the url
    `\api\v1\orders`
    The response will be an array of orders like:
```
[
  {
    "id":1,
    "status":"approved",
    "product_id":1,
    "created_at":"2019-02-06T16:51:20.491Z",
    "updated_at":"2019-02-06T16:51:20.491Z",
    "user_id":1,
    "customer_id":1
  },
  {
    "id":2,
    "status":"approved",
    "product_id":2,
    "created_at":"2019-02-06T16:51:20.500Z",
    "updated_at":"2019-02-06T16:51:20.500Z",
    "user_id":2,
    "customer_id":2
  },
  {
    "id":3,
    "status":"open",
    "product_id":3,
    "created_at":"2019-02-06T16:51:20.510Z",
    "updated_at":"2019-02-06T16:51:20.510Z",
    "user_id":3,"customer_id":3
  },
  {
    "id":4,
    "status":"cancelled",
    "product_id":4,
    "created_at":"2019-02-06T16:51:20.517Z",
    "updated_at":"2019-02-06T16:51:20.517Z",
    "user_id":4,
    "customer_id":4
  }
]
```
    *GET all orders from a especific customer
    The api expect to receive a GET in the url
    `\api\v1\customers\#{customer.id}\orders`
    The response will be an array of orders like:

```
[
  {
  "id":1,
  "status":"approved",
  "product_id":1,
  "created_at":"2019-02-06T16:35:50.098Z",
  "updated_at":"2019-02-06T16:35:50.098Z",
  "user_id":1,
  "customer_id":1
  },
  {
    "id":2,
    "status":"cancelled",
    "product_id":2,
    "created_at":"2019-02-06T16:35:50.109Z",
    "updated_at":"2019-02-06T16:35:50.109Z",
    "user_id":2,
    "customer_id":1
  }
]
```


# Requisições feitas por essa aplicação

## Para "Clientes"
Após uma aprovação do pedido uma requisição POST será enviada para a aplicação de clientes com informações do pedido.

### Header da requisição
```
Content-Type: application/json
token: 'TOKEN DA APLICAÇÃO (A DEFINIR)'
```

### Body da requisição
```
{
  customer: {
    id,
    name,
    address,
    cpf,
    email,
    phone,
    type,
    company_name,
    cnpj,
    contact,
    created_at,
    updated_at
  },
  product: {
    id,
    name,
    price,
    created_at,
    updated_at
  }
}
```

### Notas sobre os dados da requisição
O cliente está dividido entre pessoa física e pessoa jurídica. O valor de `customer` no JSON vai refletir o tipo de cliente. Clientes que são pessoas físicas vão ter os campos `cnpj`, `company_name`, `contact` como `NULL`. Clientes que são pessoas jurídicas terão os campos `name` e `cpf` como `NULL`. Todos os outros campos possuirão valores (diferentes de nulo) presentes em ambos. O valor de `type` poderá ser `Individual` (para pessoa física) ou `Company` (pessoa jurídica).  


------------------------------------------------

This README would normally document whatever steps are necessary to get the
application up and running.
Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions


