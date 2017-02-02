require "./spec_helper"

class Simple
  include AutoJson

  field :a, Int32
  field :b, String
end

describe AutoJson do
  context "converts" do
    it { Simple.new(10, "bla").to_json.should eq "{\"a\":10,\"b\":\"bla\"}" }
    it do
      s = Simple.from_json("{\"a\":10,\"b\":\"bla\"}")
      s.a.should eq 10
      s.b.should eq "bla"
    end

    it { Simple.from_json("{\"a\":10,\"b\":\"bla\"}").to_json.should eq "{\"a\":10,\"b\":\"bla\"}" }

    it do
      expect_raises(JSON::ParseException, "missing json attribute: a at 0:0") do
        Simple.from_json("{}")
      end
    end

    it "skip extra values" do
      Simple.from_json("{\"a\":10,\"b\":\"bla\",\"c\":1}").to_json.should eq "{\"a\":10,\"b\":\"bla\"}"
    end
  end
end
