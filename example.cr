require "./src/auto_json"

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
