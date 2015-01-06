# Tipi

## Usage

### Method

```ruby
method = Tipi::Method['GET']

method.verb # => 'GET'

method.safe? # => true
method.idempotent? # => true
method.cacheable? # => true

method.allows_body? # => true

method.get? # => true
method.post? # => false

method.to_s # => 'GET'
method.to_sym # => :get
```

### Status

```ruby
status = Tipi::Status[201]

status.code # => 201
status.name # => 'Created'
status.type # => :successful

status.allows_body? # => true
status.cacheable? # => false

status.to_i # => 201
status.to_s # => '201'
```
