require "./spec_helper"

struct WithDefaultsSimple
  include AutoJson
  field :a, Int32
end

struct WithDefaults
  include AutoJson

  field :a, Int32, default: 11
  field :b, String, default: "def"
  field :c, WithDefaultsSimple
end

context "with_defaults" do
  it do
    s1 = WithDefaultsSimple.new(1)
    s2 = WithDefaults.new(10, "b", s1)
    s2.a.should eq 10
    s2.b.should eq "b"
    s2.c.should eq s1
    s2.to_json.should eq "{\"a\":10,\"b\":\"b\",\"c\":{\"a\":1}}"
  end

  it "load" do
    s2 = WithDefaults.from_json("{\"a\":10,\"b\":\"b\",\"c\":{\"a\":1}}")
    s2.a.should eq 10
    s2.b.should eq "b"
    s2.c.a.should eq 1
  end

  it "load" do
    s2 = WithDefaults.from_json("{\"a\":10,\"c\":{\"a\":1}}")
    s2.a.should eq 10
    s2.b.should eq "def"
    s2.c.a.should eq 1
  end

  it "load" do
    s2 = WithDefaults.from_json("{\"c\":{\"a\":1}}")
    s2.a.should eq 11
    s2.b.should eq "def"
    s2.c.a.should eq 1
  end
end
