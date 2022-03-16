## Unreleased

- Fix Faraday v1.x deprecations.

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
