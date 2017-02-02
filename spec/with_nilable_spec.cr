require "./spec_helper"

struct WithNilableSimple
  include AutoJson
  field :a, Int32
end

struct WithNilable
  include AutoJson

  field :a, Int32
  field :b, String?
  field :d, Int32 | Nil
  field :c, WithNilableSimple
  field :e, Nil | Int32, emit_null: true
end

context "with_nilable" do
  it do
    s1 = WithNilableSimple.new(1)
    s2 = WithNilable.new(10, "b", nil, s1, 10)
    s2.a.should eq 10
    s2.b.should eq "b"
    s2.c.should eq s1
    s2.d.should eq nil
    s2.e.should eq 10
    s2.to_json.should eq "{\"a\":10,\"b\":\"b\",\"c\":{\"a\":1},\"e\":10}"
  end

  it "load" do
    s2 = WithNilable.from_json("{\"a\":10,\"b\":\"b\",\"d\":null,\"c\":{\"a\":1},\"e\":10}")
    s2.a.should eq 10
    s2.b.should eq "b"
    s2.c.a.should eq 1
    s2.d.should eq nil
    s2.e.should eq 10
  end

  it "load" do
    s2 = WithNilable.from_json("{\"a\":10,\"c\":{\"a\":1}}")
    s2.a.should eq 10
    s2.b.should eq nil
    s2.c.a.should eq 1
    s2.d.should eq nil
    s2.e.should eq nil
  end

  it "emit_null" do
    s1 = WithNilableSimple.new(1)
    s2 = WithNilable.new(a: 10, c: s1)
    s2.to_json.should eq "{\"a\":10,\"c\":{\"a\":1},\"e\":null}"
  end
end
