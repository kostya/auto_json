require "./spec_helper"

class ComplexSimple
  include AutoJson
  field x, Int32
end

class Complex
  include AutoJson
  field :x, Int32
  field :y, String, default: "def"
  field :z, Int32
  field :d, String?
  field :b, ComplexSimple, default: ComplexSimple.new(1)
end

describe AutoJson do
  context "complex" do
    it do
      c = Complex.from_json(%q<{"x":1,"z":2,"b":{"x":4}}>)
      c.x.should eq 1
      c.y.should eq "def"
      c.z.should eq 2
      c.d.should eq nil
      c.b.x.should eq 4
    end
  end
end
