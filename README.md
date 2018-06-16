# THIS PROJECT DEPRECATED, just use JSON::Serializable module instead.

# auto_json

Auto JSON convertations for classes and structs, based on [auto_constructor](https://github.com/kostya/auto_constructor) fields

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  auto_json:
    github: kostya/auto_json
```

## Usage

```crystal
require "auto_json"

struct A
  include AutoJson

  field :a, Int32
  field :b, String, default: "def"
  field :c, Int32
  field :d, String?
  field :e, Float64
end

puts A.new(a: 1, c: 3, e: 1.0).to_json      # => {"a":1,"b":"def","c":3,"e":1.0}
puts A.from_json(%q<{"a":1,"c":3,"e":1.1}>) # => A(@a=1, @b="def", @c=3, @d=nil, @e=1.1)
```

## Field options

```
  :key - set serialized key
  :json_key - set serialized key for json
  :serialize - serialize field? [true]
  :json - serialize field for json? [true]
  :converter - converter
  :json_converter - json_converter
  :emit_null - emit null in generate
  :json_emit_null - emit null in generate json
```

## Advanced Example

```crystal
require "auto_json"

struct A
  include AutoJson

  json_options(strict: true, emit_nulls: true)

  field :a, Int32, key: "bla"
  field :b, String, default: "def"
  field :c, Int32, json_key: "blc"
  field :d, String?, json_emit_null: true
  field :e, Float64, default: 1.1, json: false
  field :t, Time?, json_converter: Time::Format.new("%F %T")
end

a = A.new(a: 1, b: "b", c: 2, t: Time.now)
json = a.to_json
puts json # => {"bla":1,"b":"b","blc":2,"d":null,"t":"2017-02-02 01:38:31"}

a2 = A.from_json(json)
p a2 # => A(@a=1, @b="b", @c=2, @d=nil, @e=1.1, @t=2017-02-02 01:38:31)
```
