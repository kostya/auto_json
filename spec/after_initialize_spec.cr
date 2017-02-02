require "./spec_helper"

class AfterInitialize1
  include AutoJson
  field x, Int32

  property y : Int32
  property z : Int32

  after_initialize do
    @y = @x + 1
    @z = @y + 1
  end
end

describe AutoConstructor do
  context "after_initialize" do
    it do
      a = AfterInitialize1.from_json(%q<{"x":1}>)
      a.x.should eq 1
      a.y.should eq 2
      a.z.should eq 3
    end
  end
end
