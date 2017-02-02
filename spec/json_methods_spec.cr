require "./spec_helper"

class TestMethods
  include AutoJson

  field x, Int32
end

describe AutoJson do
  it { TestMethods.new(1).pack.should eq %q<{"x":1}> }
  it { TestMethods.new(1).to_json.should eq %q<{"x":1}> }
  it { String.build { |io| TestMethods.new(1).to_json(io) }.should eq %q<{"x":1}> }
  it { String.build { |io| TestMethods.new(1).pack(io) }.should eq %q<{"x":1}> }
  it { TestMethods.from_json(%q<{"x":1}>).x.should eq 1 }
  it { TestMethods.unpack(%q<{"x":1}>).x.should eq 1 }

  it do
    expect_raises(JSON::ParseException, "missing json attribute: x at 0:0") do
      TestMethods.unpack(%q<{}>)
    end
  end
end
