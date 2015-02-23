# Fakturoid

The Fakturoid gem is ruby library for API communication with web based invoicing service [www.fakturoid.cz](https://fakturoid.cz).
Fakturoid [API documentation](http://docs.fakturoid.apiary.io). 

[![Circle CI](https://circleci.com/gh/fakturoid/fakturoid-ruby.svg?style=svg)](https://circleci.com/gh/fakturoid/fakturoid-ruby)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fakturoid', git: 'https://github.com/fakturoid/fakturoid-ruby.git'
```

And then run:

    $ bundle

Gem is not officially released and is under construction. So if you want to use it please install it from this repository
and specify `:ref` option. API of the Fakturoid gem can be still changed.

## Configuration

Fakturoid gem is configured within config block placed in `config/initializers/fakturoid.rb`:

```ruby
Fakturoid.configure do |config|
  config.email = 'yourfakturoid@email.com'
  config.api_key = 'fasdff823fdasWRFKW843ladfjklasdf834'
  config.account = 'applecorp' # former subdomain (first part of URL)
  config.user_agent = 'Name of your app (your@email.com)'
end
```

## Usage

### Account resource

To get informations about your account in Fakturoid run following code:

```ruby
response = Fakturoid::Client::Account.current
response.status_code # returns response http code
response.body # contains hash with returned body
```

Accessing content of returned body:

```ruby
response.body['name'] # return name of your company
response.name # alternative way of getting the name of your company
```

For the list of all returned account fields see the [Account API documentation](http://docs.fakturoid.apiary.io/#account)

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

For the list of all returned user fields see the [Users API documentation](http://docs.fakturoid.apiary.io/#users)

### Subject resource

To get all subjects run (Subjects are paginated by 20 per page):

```ruby
response = Fakturoid::Client::Subject.all page: 2
```

Fulltext search subjects:

```ruby
response = Fakturoid::Client::Subject.search 'Client name'
```

To find one subject use:

```ruby
response = Fakturoid::Client::Subject.find subject_id
```

You can create new subject with:

```ruby
response = Fakturoid::Client::Subject.create name: 'New client'
```

To update subject use following code:

```ruby
response = Fakturoid::Client::Subject.update subject_id, name: 'Updated client'
```

Delete subject:

```ruby
Fakturoid::Client::Subject.delete subject_id
```

For the list of all subject fields and options see the [Subjects API documentation](http://docs.fakturoid.apiary.io/#subjects)

### Invoice resource

To get all invoices run (Invoices are paginated by 20 per page):

```ruby
response = Fakturoid::Client::Invoice.all page: 2
```

Fulltext search invoices:

```ruby
response = Fakturoid::Client::Invoice.search 'Client name'
```

To find one invoice use:

```ruby
response = Fakturoid::Client::Invoice.find invoice_id
```

To download invoice in PDF format you can use following code:

```ruby
response = Fakturoid::Client::Invoice.download_pdf invoice_id

File.open '/path/to/file.pdf', 'w' do |f|
  f.write response.body
end
```

You can create new invoice with:

```ruby
invoice = {
  subject_id: 123, 
  lines: [
    { 
      quantity: 5, 
      unit_name: 'kg', 
      name: 'Sand',
      unit_price: '100',
      vat_rate: 21
    }
  ]
}
response = Fakturoid::Client::Invoice.create invoice
```

Invoice actions (eg. pay invoice):

```ruby
response = Fakturoid::Client::Invoice.fire invoice_id, 'pay'
```

To update invoice use following code:

```ruby
response = Fakturoid::Client::Invoice.update invoice_id, number: '2015-0015'
```

Delete invoice:

```ruby
response = Fakturoid::Client::Invoice.delete invoice_id
```

For the list of all invoice fields and options see the [Invoices API documentation](http://docs.fakturoid.apiary.io/#invoices)

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
