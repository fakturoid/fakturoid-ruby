## 0.5.0

- Add support for inventory items and moves.

## 0.4.0

- Fix Faraday v1.x deprecations.
- Add support for Faraday v2.x.
- Add support form number formats endpoint

  ```ruby
  number_formats = Fakturoid::Client::NumberFormat.invoices
  ```

- Add support for `until`, `updated_until` and `custom_id`
params to invoice index action methods

  ```ruby
  invoices = Fakturoid::Client::Invoice.all(since: "2022-03-01T00:00:00+01:00", until: "2022-03-31T23:59:59+01:00")
  invoices = Fakturoid::Client::Invoice.regular(updated_since: "2022-03-01T00:00:00+01:00", updated_until: "2022-03-31T23:59:59+01:00")
  proformas = Fakturoid::Client::Invoice.proforma(custom_id: "custom-123")
  ```

- Add support for `custom_id` param to expense index action method

  ```ruby
  Fakturoid::Client::Expense.all(custom_id: "custom-123")
  ```

- Add support for pagination to search endpoints

  ```ruby
  Fakturoid::Client::Invoice.search("apples", page: 3)
  Fakturoid::Client::Expense.search("computers", page: 2)
  Fakturoid::Client::Subject.search("apple", page: 2)
  ```

## 0.3.0

- Add support for `variable_symbol` and `bank_account_id` param in invoice `fire` method.

  ```ruby
  Fakturoid::Client::Invoice.fire(1234, 'pay', paid_at: '2017-07-03', paid_amount: '100.23', variable_symbol: '12345678', bank_account_id: 123)
  ```

- Add support for `paid_on`, `paid_amount`, `variable_symbol` and `bank_account_id` params in expense `fire` method.

  ```ruby
  Fakturoid::Client::Expense.fire(1234, 'pay', paid_on: '2017-07-03', paid_amount: '100.23', variable_symbol: '12345678', bank_account_id: 123)
  ```

## 0.2.1

- Add support for `paid_amount` param in invoice `fire` method.

  ```ruby
  Fakturoid::Client::Invoice.fire(1234, 'pay', paid_at: '2017-07-03', paid_amount: '100.23')
  ```

## 0.2.0

- Add support for `paid_at` param in invoice `fire` method.

  ```ruby
  Fakturoid::Client::Invoice.fire(1234, 'pay', paid_at: '2017-07-03')
  ```

## 0.1.1

- Added support for `updated_since` param.
- Defined `respond_to_missing?` method for `Response` class. Example:

  ```ruby
  ### Before
  invoice = Fakturoid::Client::Invoice.find(1234)
  invoice.respond_to?(:number)
  # => false

  ### After
  invoice = Fakturoid::Client::Invoice.find(1234)
  invoice.respond_to?(:number)
  # => true
  ```

## 0.1.0 (Initial version)
