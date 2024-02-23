# Fakturoid

The Fakturoid gem is ruby library for API communication with web based invoicing service [www.fakturoid.cz](https://fakturoid.cz).
Fakturoid [API documentation](https://fakturoid.docs.apiary.io/).

[![Gem Version](https://badge.fury.io/rb/fakturoid.svg)](http://badge.fury.io/rb/fakturoid)
[![Tests](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/tests.yml/badge.svg)](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/tests.yml)
[![Rubocop](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/rubocop.yml/badge.svg)](https://github.com/fakturoid/fakturoid-ruby/actions/workflows/rubocop.yml)

## Installation

Add this line to your application's Gemfile:

```ruby
gem "fakturoid"
```

And then run:

    $ bundle

## Configuration

Fakturoid gem is configured within config block placed in `config/initializers/fakturoid.rb`:

### Authorization by OAuth 2.0

You can read more about authorization on our web [](https://www.fakturoid.cz/podpora/automatizace/api#api-v3-pristupove-udaje)

#### Authorization Code Flow

```ruby
Fakturoid.configure do |config|
  config.email = "yourfakturoid@email.com"
  config.client_id = "{fakturoid-client-id}"
  config.client_secret = "{fakturoid-client-secret}"
  # config.account = "{fakturoid-account-slug}" # Or set this later dynamically
  config.user_agent = "Name of your app (your@email.com)"
end

# To be rendered on a web page. State is optional.
link_to Fakturoid.auth.url, "Enable Fakturoid Integration"
link_to Fakturoid.auth.url(state: "abcd1234"), "Enable Fakturoid Integration"

# `Fakturoid.auth.credentials` will always return current credentials.
credentials = Fakturoid.auth.request_credentials(code: params[:code])
credentials = Fakturoid.auth.credentials

# You can load credentials from external store and pass it into the setter.
Fakturoid.auth.credentials = {
  access_token: "a6d3b9de2d9df5af5f57200151df5c85790c9106cd212856aec9a057eed969ff53ce1e7a9aa563e2",
  refresh_token: "ea6948de33042ee3d06b7764dfa620285c67689aea98e29a093538c572c6743d7862417c69ae2ad3",
  expires_at: "2024-02-23T17:24:53+01:00"
}

# Dynamically set account slug.
Fakturoi.account = Fakturoid::Client::User.current.body["accounts"].first["slug"]

# Refresh will be called automatically but it can be triggered manually.
Fakturoid.auth.refresh_access_token
Fakturoid.auth.revoke_access

# Don't forget to update your `access_code` when it gets refreshed.
Fakturoid.auth.on_access_token_refresh do |credentials|
  # Store new credentials into database.
end
```

#### Client Credentials Flow

```ruby
Fakturoid.configure do |config|
  config.email = "yourfakturoid@email.com"
  config.client_id = "{fakturoid-client-id}"
  config.client_secret = "{fakturoid-client-secret}"
  config.account = "{fakturoid-account-slug}"
  config.user_agent = "Name of your app (your@email.com)"
end

# `Fakturoid.auth.credentials` will always return current credentials.
credentials = Fakturoid.auth.request_client_credentials
credentials = Fakturoid.auth.credentials

# You can load credentials from external store and pass it into the setter.
Fakturoid.auth.credentials = {
  access_token: "2cb5a4fced155320a98fc3d6667fa5aa4e0c8fc7fae48d610acd26149ab0e360d3a4070ab0c1f8d4",
  expires_at: "2024-02-23T19:40:43+01:00"
}

# Don't forget to update your `access_code` when it gets refreshed.
Fakturoid.auth.on_access_token_refresh do |credentials|
  # Store new credentials into database.
end
```

## Usage

### Account resource

To get information about your account in Fakturoid run following code:

```ruby
response = Fakturoid::Client::Account.current
response.status_code # returns response http code
response.body # contains hash with returned body
```

Accessing content of returned body:

```ruby
response.body["name"] # return name of your company
response.name # alternative way of getting the name of your company
```

For the list of all returned account fields see the [Account API documentation](https://fakturoid.docs.apiary.io/#reference/account)

### User resource

For the information about current user use following code:

```ruby
response = Fakturoid::Client::User.current
```

For all the users which belongs to current account:

```ruby
response = Fakturoid::Client::User.all
```

If you want to get information about one user which belongs to account use:

```ruby
response = Fakturoid::Client::User.find(user_id)
```

For the list of all returned user fields see the [Users API documentation](https://fakturoid.docs.apiary.io/#reference/users)

### Number Format resource

For the list of invoice number formats which belong to the current account:

```ruby
response = Fakturoid::Client::NumberFormat.invoices
```

For the list of all returned user fields see the [Number formats API documentation](https://fakturoid.docs.apiary.io/#reference/number-formats)

### Subject resource

To get all subjects run (Subjects are paginated by 20 per page):

```ruby
response = Fakturoid::Client::Subject.all(page: 2)
```

Fulltext search subjects:

```ruby
response = Fakturoid::Client::Subject.search("Client name")
```

To find one subject use:

```ruby
response = Fakturoid::Client::Subject.find(subject_id)
```

You can create new subject with:

```ruby
response = Fakturoid::Client::Subject.create(name: "New client")
```

To update subject use following code:

```ruby
response = Fakturoid::Client::Subject.update(subject_id, name: "Updated client")
```

Delete subject:

```ruby
Fakturoid::Client::Subject.delete subject_id
```

For the list of all subject fields and options see the [Subjects API documentation](https://fakturoid.docs.apiary.io/#reference/subjects)

### Invoice resource

To get all invoices run (Invoices are paginated by 20 per page):

```ruby
response = Fakturoid::Client::Invoice.all(page: 2)
```

Fulltext search invoices:

```ruby
response = Fakturoid::Client::Invoice.search("Client name")
```

To find one invoice use:

```ruby
response = Fakturoid::Client::Invoice.find(invoice_id)
```

To download invoice in PDF format you can use following code:

```ruby
response = Fakturoid::Client::Invoice.download_pdf(invoice_id)

File.open("/path/to/file.pdf", "wb") do |f|
  f.write(response.body)
end
```

You can create new invoice with:

```ruby
invoice = {
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
response = Fakturoid::Client::Invoice.create(invoice)
```

Invoice actions (eg. pay invoice):

```ruby
response = Fakturoid::Client::Invoice.fire(invoice_id, "pay")
```

Send invoice with customized message (for more information see [the API Documentation](https://fakturoid.docs.apiary.io/#reference/messages)):

```ruby
message = {
  email: "testemail@testemail.cz",
  email_copy: "some@emailcopy.cz",
  subject: "I have an invoice for you",
  message: "Hi,\n\nyou can find invoice no. #no# on the following page #link#\n\nHave a nice day"
}

response = Fakturoid::Client::Invoice.deliver_message(181, message)
response.status_code # => 201
```

To update invoice use following code:

```ruby
response = Fakturoid::Client::Invoice.update(invoice_id, number: "2015-0015")
```

Delete invoice:

```ruby
response = Fakturoid::Client::Invoice.delete(invoice_id)
```

For the list of all invoice fields and options see the [Invoices API documentation](https://fakturoid.docs.apiary.io/#reference/invoices)

### InventoryItem resource

To get all inventory items:

```ruby
response = Fakturoid::Client::InventoryItems.all
```

To filter inventory items by certain SKU code:

```ruby
response = Fakturoid::Client::InventoryItems.all(sku: 'SKU1234')
```

To search inventory items (searches in `name`, `article_number` and `sku`):

```ruby
response = Fakturoid::Client::InventoryItems.search('Item name')
```

To get all archived inventory items:

```ruby
response = Fakturoid::Client::InventoryItems.archived
```

To get a single inventory item:

```ruby
response = Fakturoid::Client::InventoryItems.find(inventory_item_id)
```

To create an inventory item:

```ruby
inventory_item = {
  name: "Item name",
  sku: "SKU1234",
  track_quantity: true,
  quantity: 100,
  native_purchase_price: 500,
  native_retail_price: 1000
}
response = Fakturoid::Client::InventoryItems.create(inventory_item)
```

To update an inventory item:

```ruby
response = Fakturoid::Client::InventoryItems.update(inventory_item_id, name: "Another name")
```

To archive an inventory item:

```ruby
response = Fakturoid::Client::InventoryItems.archive(inventory_item_id)
```

To unarchive an inventory item:

```ruby
response = Fakturoid::Client::InventoryItems.unarchive(inventory_item_id)
```

To delete an inventory item:

```ruby
response = Fakturoid::Client::InventoryItems.delete(inventory_item_id)
```

### InventoryMove resource

To get get all inventory moves across all inventory items:

```ruby
response = Fakturoid::Client::InventoryMoves.all
```

To get inventory moves for a single inventory item:

```ruby
response = Fakturoid::Client::InventoryMoves.all(inventory_item_id: inventory_item_id)
```

To get a single inventory move:

```ruby
response = Fakturoid::Client::InventoryMoves.find(inventory_item_id, inventory_move_id)
```

To create a stock-in inventory move:

```ruby
response = Fakturoid::Client::InventoryMoves.create(
  inventory_item_id,
  direction: "in",
  moved_on: Date.today,
  quantity_change: 5,
  purchase_price: "249.99",
  purchase_currency: "CZK",
  private_note: "Bought with discount"
)
```

To create a stock-out inventory move:

```ruby
response = Fakturoid::Client::InventoryMoves.create(
  inventory_item_id,
  direction: "out",
  moved_on: Date.today,
  quantity_change: "1.5",
  retail_price: 50,
  retail_currency: "EUR",
  native_retail_price: "1250"
)
```

To update an inventory move:

```ruby
inventory_move = {
  private_note: "Text"
  # Plus other fields if necessary
}
response = Fakturoid::Client::InventoryMoves.update(inventory_item_id, inventory_move_id, inventory_move)
```

To delete an inventory move:

```ruby
response = Fakturoid::Client::InventoryMoves.delete(inventory_item_id, inventory_move_id)
```

## Handling error responses

The Fakturoid gem raises exceptions if error response is returned from the servers. All exceptions contains following attributes:

  - `message` - Error description
  - `response_code` - http code of error (only number)
  - `response_body` - response body parsed in the hash

<table>
  <thead>
    <tr>
      <th>Error class</th><th>Response code</th><th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>ContentTypeError</td><td>415 Unsupported Media Type</td><td>Wrong content type</td>
    </tr>
    <tr>
      <td>UserAgentError</td><td>400 Bad Request</td><td>Missing `user_agent` configuration</td>
    </tr>
    <tr>
      <td>PaginationError</td><td>400 Bad Request</td><td>Page with given number does not exist</td>
    </tr>
    <tr>
      <td>AuthenticationError</td><td>401 Unauthorized</td><td>Wrong authentication `email` or `api_key` configuration</td>
    </tr>
    <tr>
      <td>BlockedAccountError</td><td>402 Payment Required</td><td>Fakturoid account is blocked</td>
    </tr>
    <tr>
      <td>RateLimitError</td><td>429 Too Many Requests</td><td>Too many request sent during last 5 minutes</td>
    </tr>
    <tr>
      <td>ReadOnlySiteError</td><td>503 Service Unavailable</td><td>Fakturoid is read only</td>
    </tr>
    <tr>
      <td>RecordNotFoundError</td><td>404 Not Found</td><td>Document with given ID does not exists or current account has read only permission and trying to edit something</td>
    </tr>
    <tr>
      <td>InvalidRecordError</td><td>422 Unprocessable Entity</td><td>Invalid data sent to server</td>
    </tr>
    <tr>
      <td>DestroySubjectError</td><td>403 Forbidden</td><td>Subject has invoices or expenses and cannot be deleted</td>
    </tr>
    <tr>
      <td>SubjectLimitError</td><td>403 Forbidden</td><td>Subject quota reached for adding more subjects upgrade to higher plan</td>
    </tr>
    <tr>
      <td>GeneratorLimitError</td><td>403 Forbidden</td><td>Generator quota reached for adding more recurring generators upgrade to higher plan</td>
    </tr>
    <tr>
      <td>UnsupportedFeatureError</td><td>403 Forbidden</td><td>Feature is not supported in your plan to use this feature upgrade to higher plan</td>
    </tr>
    <tr>
      <td>ClientError</td><td>4XX</td><td>Server returns response code which is not specified above</td>
    </tr>
    <tr>
      <td>ServerError</td><td>5XX</td><td>Server returns response code which is not specified above</td>
    </tr>
  </tbody>
</table>

## Development

```sh
git clone <repo-url>
cd fakturoid-ruby
bundle
bundle exec rake # Run tests
bundle exec rake build # Test the package building process
```
