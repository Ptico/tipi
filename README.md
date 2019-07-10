# Tipi

Object-oriented HTTP primitives. Based on info from  [know-your-http-well](https://github.com/for-GET/know-your-http-well) and [rfc2068](http://tools.ietf.org/html/rfc2068)

## Usage

### Method

This is how `Tipi::Method` instance looks like:

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

You can get method instance(s) with next class methods:

```ruby
Tipi::Method.all          # Will return array of registered `Tipi::Method` instances
Tipi::Method['POST']      # Works only with upcased verb string
Tipi::Method.fetch(:post) # Works as `Hash#fetch` but first key may be symbol and downcased string
```

Also it is possible to register additional method:

```ruby
Tipi::Method.registered?('BIND') # => false
Tipi::Method.register('BIND', safe: false, idempotent: true, cacheable: false)

Tipi::Method.registered?('BIND') # => true
Tipi::Method.registered?(:bind) # => true (the same)

Tipi::Method['BIND'].bind? # => true
Tipi::Method['GET'].bind? # => false
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

`Tipi::Status` can be retrieved like `Tipi::Method`:

```ruby
Tipi::Status.all          # Will return array of registered `Tipi::Status` instances
Tipi::Status[404]         # Works only with fixnum
Tipi::Status.fetch('404') # Works as `Hash#fetch` but first key may be a string
```

It can also be registered:

```ruby
Tipi::Status.registered?(226) # => false
Tipi::Status.register(226, 'IM Used', cacheable: false, allows_body: true)

Tipi::Status.registered?(226) # => true
Tipi::Status.registered?('226') # => true (the same)
```

### Header

```ruby
rule = Tipi::Header['If-Modified-Since'].call('Mon, 06 Aug 2012 02:17:00 GMT')
rule.value.year #=> 2012
rule.value.day #=> 6
rule.to_s #=> "If-Modified-Since: Mon, 06 Aug 2012 02:17:00 GMT"

exp = Tipi::Header['Expires'].set(Time.now + 300)
flush_cache! if exp.value > DateTime.now

exp = Tipi::Header['Expires'].set('29 Aug 1997')
exp.http_value #=> 'Fri, 29 Aug 1997 00:00:00 GMT'

cl = Tipi::Header['Content-Length'].call('2100')
cl.value #=> 2100
cl.to_s #=> 'Content-Length: 2100'
```
