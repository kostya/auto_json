require "./spec_helper"

struct DataMoreFieldsSimple
  include AutoJson
  field :a, Int32
end

struct DataMoreFields
  include AutoJson

  field :a, Int32
  field :b, String
  field :c, Array(DataMoreFieldsSimple)
end

describe AutoJson do
  data = {DataMoreFieldsSimple.new(3),
    2,
    DataMoreFields.new(1, "bla", [DataMoreFieldsSimple.new(1), DataMoreFieldsSimple.new(2)]),
    [DataMoreFields.new(1, "b", [] of DataMoreFieldsSimple)],
    {key: DataMoreFieldsSimple.new(10)},
    {"key2" => DataMoreFieldsSimple.new(11)},
  }
  js = "[{\"a\":3},2,{\"a\":1,\"b\":\"bla\",\"c\":[{\"a\":1},{\"a\":2}]},[{\"a\":1,\"b\":\"b\",\"c\":[]}],{\"key\":{\"a\":10}},{\"key2\":{\"a\":11}}]"

  it "pack" do
    data.to_json.should eq js
  end

  it "unpack" do
    typeof(data).from_json(js).should eq data
  end
end
