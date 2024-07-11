# Fakturoid

The Fakturoid gem is Ruby library for API communication with web based invoicing service [www.fakturoid.cz](https://www.fakturoid.cz/).

Fakturoid [API documentation](https://www.fakturoid.cz/api/v3).

[![Gem Version](https://badge.fury.io/rb/fakturoid.svg)](http://badge.fury.io/rb/fakturoid)
[![Tests](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/tests.yml/badge.svg)](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/tests.yml)
[![Rubocop](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/rubocop.yml/badge.svg)](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/rubocop.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fakturoid"
```

And then run:

```sh
bundle
```

## Gem Versions

| Gem version | Fakturoid API                               | Supported Ruby |
|-------------|---------------------------------------------|----------------|
| `1.x`       | [API v3](https://www.fakturoid.cz/api/v3)   | `>=2.7.0`      |
| `0.x`       | [API v2](https://fakturoid.docs.apiary.io/) | `>=2.7.0`      |

## Configuration

### Authorization with OAuth 2.0

#### Authorization Code Flow

Authorization using OAuth takes place in several steps. We use data obtained from the developer portal as client ID and
client secret (Settings → Connect other apps → OAuth 2 for app developers).

First, we offer the user a URL address where he enters his login information. We obtain this using the following method
(you can place it in an intializer `config/initializers/fakturoid.rb`):

```ruby
Fakturoid.configure do |config|
  config.email         = "yourfakturoid@email.com"
  config.account       = "{fakturoid-account-slug}" # You can also set `account` dynamically later.
  config.user_agent    = "Name of your app (your@email.com)"
  config.client_id     = "{fakturoid-client-id}"
  config.client_secret = "{fakturoid-client-secret}"
  config.redirect_uri  = "{your-redirect-uri}"
  config.oauth_flow    = "authorization_code"
end
```

Create a client and let the user come to our OAuth login page:

```ruby
client = Fakturoid.client

# To be rendered on a web page. State is optional.
link_to client.authorization_uri, "Enable Fakturoid Integration"
link_to client.authorization_uri(state: "abcd1234"), "Enable Fakturoid Integration"
```

After entering the login data, the user is redirected to the specified redirect URI and with the code with which we
obtain his credentials. We process the code as follows:

```ruby
client.authorize(code: params[:code])
```

Credentials are now established in the object instance and we can send queries to the Fakturoid API.

```ruby
pp client.credentials.as_json
```

Credentials can also be set manually (eg. loaded from a database):

```ruby
client.credentials = {
  access_token: "1db22484a6d6256e7942158d216157d075ab6e7b583bd16416181ca6c4ac180167acd8d599bd123d", # Example
  refresh_token: "5682a4bc6254d85934a03931ed5e235e0f81bca64aef054fa0049d8c953eab919ba67bd8ceb532d7",
  expires_at: "2024-03-01T12:42:40+01:00", # This also accepts `Time` or `DateTime` object.
  token_type: "Bearer"
}
```

Don't forget to update your credentials after an access token refresh:

```ruby
client.credentials_updated_callback do |credentials|
  # Store new credentials into database.
  pp client.credentials.as_json
end
```

You may need to set account slug dynamically:

```ruby
client.account = client.users.current.body["accounts"].first["slug"]
```

And if you need to create a separate client for a different account:

```ruby
client = Fakturoid::Client.new(account: "{another-fakturoid-account-slug}")
```

Revoke access altogether (works in both flows):

```ruby
client.revoke_access
```

#### Client Credentials Flow

```ruby
Fakturoid.configure do |config|
  config.email         = "yourfakturoid@email.com"
  config.account       = "{fakturoid-account-slug}"
  config.user_agent    = "Name of your app (your@email.com)"
  config.client_id     = "{fakturoid-client-id}"
  config.client_secret = "{fakturoid-client-secret}"
  config.oauth_flow    = "client_credentials"
end
```

Credentials can be set and stored the same way as above just without a refresh token.

## Usage

Almost all resources that return a list of things are paginated by 40 per page. You can specify the page number
by passing a `page` parameter: `client.some_resource.all(page: 2)`.

### [User Resource](https://www.fakturoid.cz/api/v3/users)

Get current user information along with a list of accounts he/she has access to

```ruby
response = client.users.current
response.status_code # Returns response HTTP code.
response.body # Contains hash with returned body (JSON is parsed automatically).
```

Accessing content of returned body:

```ruby
response.body["name"] # Return name of your company.
response.name # Alternative way of getting the name of your company.
```

Get a list of all account users:

```ruby
response = client.users.all
```

### [Account Resource](https://www.fakturoid.cz/api/v3/account)

Get Fakturoid account information:

```ruby
response = client.account.current
```

### [Bank Account Resource](https://www.fakturoid.cz/api/v3/bank-accounts)

Get a list of bank accounts for current account:

```ruby
response = client.bank_accounts.all
```

### [Number Format Resource](https://www.fakturoid.cz/api/v3/number-formats)

Get a list of invoice number formats for current account:

```ruby
response = client.number_formats.invoices
```

### [Subject Resource](https://www.fakturoid.cz/api/v3/subjects)

Get a list of subjects:

```ruby
response = client.subjects.all(page: 2)
```

Fulltext search:

```ruby
response = client.subjects.search(query: "Client name")
```

Get a specific subject:

```ruby
response = client.subjects.find(subject_id)
```

Create a new subject:

```ruby
response = client.subjects.create(name: "New client")
```

Update a subject:

```ruby
response = client.subjects.update(subject_id, name: "Updated client")
```

Delete a subject:

```ruby
client.subjects.delete(subject_id)
```

### [Invoice Resource](https://www.fakturoid.cz/api/v3/invoices)

Get a list of invoices:

```ruby
response = client.invoices.all
```

Fulltext search:

```ruby
response = client.invoices.search(query: "Client name")
response = client.invoices.search(tags: "Housing")
response = client.invoices.search(tags: ["Housing", "Rent"])
response = client.invoices.search(query: "Client name", tags: ["Housing"])
```

Get invoice details:

```ruby
response = client.invoices.find(invoice_id)
```

Download invoice in PDF format:

```ruby
response = client.invoices.download_pdf(invoice_id)

File.open("/path/to/file.pdf", "wb") do |f|
  f.write(response.body)
end
```

Download an attachment:

```ruby
response = client.invoices.download_attachment(invoice_id, attachment_id)

File.open("/path/to/attachment.pdf", "wb") do |f|
  f.write(response.body)
end
```

Invoice actions (eg. lock invoice, cancel, etc., full list is in the API documentation):

```ruby
response = client.invoices.fire(invoice_id, "lock")
```

Create an invoice:

```ruby
data = {
  subject_id: 123,
  lines: [
    {
      quantity: 5,
      unit_name: "kg",
      name: "Sand",
      unit_price: "100",
      vat_rate: 21
    }
  ]
}
response = client.invoices.create(data)
```

Update an invoice:

```ruby
response = client.invoices.update(invoice_id, number: "2015-0015")
```

Delete an invoice:

```ruby
response = client.invoices.delete(invoice_id)
```

### [Invoice Payment Resource](https://www.fakturoid.cz/api/v3/invoice-payments)

Create an invoice payment:

```ruby
response = client.invoice_payments.create(invoice_id, paid_on: Date.today)
response = client.invoice_payments.create(invoice_id, amount: "500")
````

Create a tax document for a payment:

```ruby
response = client.invoice_payments.create_tax_document(invoice_id, payment_id)
tax_document_response = client.invoices.find(response.tax_document_id)
````

Delete a payment:

```ruby
response = client.invoice_payments.delete(invoice_id, payment_id)
```

### [Invoice Message Resource](https://www.fakturoid.cz/api/v3/invoice-messages)

Send a message to the client (you can use more variables in the `message`, full list is in the API documentation):

```ruby
data = {
  email: "testemail@testemail.cz",
  email_copy: "some@emailcopy.cz",
  subject: "I have an invoice for you",
  message: "Hi,\n\nyou can find invoice no. #no# on the following page #link#\n\nHave a nice day"
}

response = client.invoice_messages.create(invoice_id, data)
```

### [Expense Resource](https://www.fakturoid.cz/api/v3/expenses)

Get a list of expenses:

```ruby
response = client.expenses.all
```

Fulltext search:

```ruby
response = client.expenses.search(query: "Supplier name")
response = client.expenses.search(tags: "Housing")
response = client.expenses.search(tags: ["Housing", "Rent"])
response = client.expenses.search(query: "Supplier name", tags: ["Housing"])
```

Get expense details:

```ruby
response = client.expenses.find(expense_id)
```

Download an attachment:

```ruby
response = client.expenses.download_attachment(expense_id, attachment_id)

File.open("/path/to/attachment.pdf", "wb") do |f|
  f.write(response.body)
end
```

Expense actions (eg. lock expense etc., full list is in the API documentation):

```ruby
response = client.expenses.fire(expense_id, "lock")
```

Create an expense:

```ruby
data = {
  subject_id: 123,
  lines: [
    {
      quantity: 5,
      unit_name: "kg",
      name: "Sand",
      unit_price: "100",
      vat_rate: 21
    }
  ]
}
response = client.expenses.create(data)
```

Update an expense:

```ruby
response = client.expenses.update(expense_id, number: "N20240201")
```

Delete an expense:

```ruby
response = client.expenses.delete(expense_id)
```

### [Expense Payment Resource](https://www.fakturoid.cz/api/v3/expense-payments)

Create an expense payment:

```ruby
response = client.expense_payments.create(expense_id, paid_on: Date.today)
response = client.expense_payments.create(expense_id, amount: "500")
````

Delete a payment:

```ruby
response = client.expense_payments.delete(expense_id, payment_id)
```

### [Inbox File Resource](https://www.fakturoid.cz/api/v3/inbox-files)

Get a list of inbox files:

```ruby
response = client.inbox_files.all
```

Create an inbox file:
  
```ruby
require "base64"

client.inbox_files.create(
  attachment: "data:application/pdf;base64,#{Base64.urlsafe_encode64(File.read("some-file.pdf"))}",
  filename: "some-file.pdf", # This is optional and defaults to `attachment.{extension}`.
  send_to_ocr: true          # Also optional
)
```

Send a file to OCR (data extraction service):

```ruby
client.inbox_files.send_to_ocr(inbox_file_id)
```

Download a file:

```ruby
filename = client.inbox_files.find(inbox_file_id).filename
response = client.inbox_files.download(inbox_file_id)

File.open("/path/to/file.pdf", "wb") do |f|
  f.write(response.body)
end
```

Delete a file:

```ruby
response = client.inbox_files.delete(inbox_file_id)
```

### [InventoryItem Resource](https://www.fakturoid.cz/api/v3/inventory-items)

Get a list of inventory items:

```ruby
response = client.inventory_items.all
response = client.inventory_items.all(sku: "SKU1234") # Filter by SKU code
```

Get a list of archived inventory items:

```ruby
response = client.inventory_items.archived
```

Get a list of inventory items that are running low on quantity:

```ruby
response = client.inventory_items.low_quantity
```

Search inventory items (searches in `name`, `article_number` and `sku`):

```ruby
response = client.inventory_items.search(query: "Item name")
```

Get a single inventory item:

```ruby
response = client.inventory_items.find(inventory_item_id)
```

Create an inventory item:

```ruby
data = {
  name: "Item name",
  sku: "SKU1234",
  track_quantity: true,
  quantity: 100,
  native_purchase_price: 500,
  native_retail_price: 1000
}
response = client.inventory_items.create(data)
```

Update an inventory item:

```ruby
response = client.inventory_items.update(inventory_item_id, name: "Another name")
```

Delete an inventory item:

```ruby
response = client.inventory_items.delete(inventory_item_id)
```

Archive an inventory item:

```ruby
response = client.inventory_items.archive(inventory_item_id)
```

Unarchive an inventory item:

```ruby
response = client.inventory_items.unarchive(inventory_item_id)
```

### [InventoryMove Resource](https://www.fakturoid.cz/api/v3/inventory-moves)

Get a list of inventory moves across all inventory items:

```ruby
response = client.inventory_moves.all
```

Get a list of inventory moves for a single inventory item:

```ruby
response = client.inventory_moves.all(inventory_item_id: inventory_item_id)
```

Get a single inventory move:

```ruby
response = client.inventory_moves.find(inventory_item_id, inventory_move_id)
```

Create a stock-in inventory move:

```ruby
response = client.inventory_moves.create(
  inventory_item_id,
  direction: "in",
  moved_on: Date.today,
  quantity_change: 5,
  purchase_price: "249.99",
  purchase_currency: "CZK",
  private_note: "Bought with discount"
)
```

Create a stock-out inventory move:

```ruby
response = client.inventory_moves.create(
  inventory_item_id,
  direction: "out",
  moved_on: Date.today,
  quantity_change: "1.5",
  retail_price: 50,
  retail_currency: "EUR",
  native_retail_price: "1250"
)
```

Update an inventory move:

```ruby
data = {
  private_note: "Text"
  # Plus other fields if necessary
}
response = client.inventory_moves.update(inventory_item_id, inventory_move_id, data)
```

Delete an inventory move:

```ruby
response = client.inventory_moves.delete(inventory_item_id, inventory_move_id)
```

### [Generator Resource](https://www.fakturoid.cz/api/v3/generators)

Get a list of generators:

```ruby
response = client.generators.all
```

Get generator details:

```ruby
response = client.generators.find(generator_id)
```

Create a generator:

```ruby
data = {
  name: "Workshop",
  subject_id: 123,
  lines: [
    {
      quantity: 5,
      unit_name: "kg",
      name: "Sand",
      unit_price: "100",
      vat_rate: 21
    }
  ]
}
response = client.generators.create(data)
```

Update an generator:

```ruby
response = client.generators.update(generator_id, name: "Another name")
```

Delete an generator:

```ruby
response = client.generators.delete(generator_id)
```

### [RecurringGenerator Resource](https://www.fakturoid.cz/api/v3/recurring-generators)

Get a list of recurring generators:

```ruby
response = client.recurring_generators.all
```

Get recurring generator details:

```ruby
response = client.recurring_generators.find(recurring_generator_id)
```

Create a recurring generator:

```ruby
data = {
  name: "Workshop",
  subject_id: subject_id,
  start_date: Date.today,
  months_period: 1,
  lines: [
    {
      quantity: 5,
      unit_name: "kg",
      name: "Sand",
      unit_price: "100",
      vat_rate: 21
    }
  ]
}
response = client.recurring_generators.create(data)
```

Update a recurring generator:

```ruby
response = client.recurring_generators.update(recurring_generator_id, name: "Another name")
```

Delete a recurring generator:

```ruby
response = client.recurring_generators.delete(recurring_generator_id)
```
### [Event Resource](https://www.fakturoid.cz/api/v3/events)

Get a list of all events:

```ruby
response = client.events.all
````

Get a list of document-paid events:

```ruby
response = client.events.paid
````

### [Todo Resource](https://www.fakturoid.cz/api/v3/todos)

Get a list of all todos:

```ruby
response = client.todos.all
````

Toggle a todo completion:

```ruby
response = client.todos.toggle_completion(todo_id)
```

### [Webhook Resource](https://www.fakturoid.cz/api/v3/webhooks)

Get a list of all webhooks:

```ruby
response = client.webhooks.all
```

Get a single webhook:

```ruby
response = client.webhooks.find(webhook_id)
```

Create a webhook:

```ruby
response = client.webhooks.create(url: "https://example.com/webhook", events: %w[invoice_created])
```

Update a webhook:

```ruby
response = client.webhooks.update(webhook_id, url: "https://example.com/webhook")
```

Delete a webhook:

```ruby
response = client.webhooks.delete(webhook_id)
```

## Handling Errors

The Fakturoid gem raises exceptions if server responds with an error.
All exceptions except `ConfigurationError` contain following attributes:

- `message`: Error description
- `response_code`: HTTP code of error (only number)
- `response_body`: Response body parsed as a hash

<table>
  <thead>
    <tr>
      <th>Error class</th><th>Response code</th><th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ConfigurationError</td><td>N/A</td><td>Important configuration is missing.</td>
    </tr>
    <tr>
      <td>OauthError</td><td>400 Bad Request</td><td>OAuth request fails.</td>
    </tr>
    <tr>
      <td>AuthenticationError</td><td>401 Unauthorized</td><td>Authentication fails due to client credentials error or access token expired.</td>
    </tr>
    <tr>
      <td>ClientError</td><td>4XX</td><td>User-sent data are invalid.</td>
    </tr>
    <tr>
      <td>ServerError</td><td>5XX</td><td>An exception happened while processing a request.</td>
    </tr>
  </tbody>
</table>

## Contributing

- Make a pull request with requested changes.
- Make sure the pull request is as small as possible. If you encounter something that should be changed but is unrelated,
  please make a separate pull request for that.
- Do not change the version number inside the pull request – this will be done after it is merged.

## Development

```sh
git clone <repo-url>
cd fakturoid-ruby
bundle
bundle exec rake # Run tests
bundle exec rake build # Test the package building process
```
