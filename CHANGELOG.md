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
