require "./spec_helper"

struct UnionTest
  include AutoJson

  field :a, Int32 | String
end

describe AutoJson do
  it { UnionTest.from_json(%q<{"a":1}>).a.should eq 1 }
  it { UnionTest.from_json(%q<{"a":"1"}>).a.should eq "1" }

  it { UnionTest.new(1).to_json.should eq %q<{"a":1}> }
  it { UnionTest.new("1").to_json.should eq %q<{"a":"1"}> }
end
