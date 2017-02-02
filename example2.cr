require "./src/auto_json"

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
