require "./spec_helper"

struct EmitNulls1
  include AutoJson

  json_options(emit_nulls: true)

  field :a, Int32?
  field :b, String?
end

struct EmitNulls2
  include AutoJson

  field :a, Int32?, emit_null: true
  field :b, String?, json_emit_null: true
end

context "emit_null" do
  it { EmitNulls1.new.to_json.should eq %q<{"a":null,"b":null}> }
  it { EmitNulls1.new(1).to_json.should eq %q<{"a":1,"b":null}> }

  it { EmitNulls2.new.to_json.should eq %q<{"a":null,"b":null}> }
  it { EmitNulls2.new(1).to_json.should eq %q<{"a":1,"b":null}> }
end
