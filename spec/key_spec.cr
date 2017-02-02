require "./spec_helper"

struct WithKeys
  include AutoJson

  field :a, Int32, key: "bla"
  field :b, Int32, json_key: :bla2
end

describe AutoJson do
  it do
    WithKeys.new(1, 2).to_json.should eq %q<{"bla":1,"bla2":2}>
  end

  it do
    w = WithKeys.from_json(%q<{"bla":1,"bla2":2}>)
    w.a.should eq 1
    w.b.should eq 2
  end

  it do
    expect_raises(JSON::ParseException, "missing json attribute: bla") do
      WithKeys.from_json(%q<{"a":1,"b":2}>)
    end
  end
end
