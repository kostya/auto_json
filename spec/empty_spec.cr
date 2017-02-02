require "./spec_helper"

class Empty
  include AutoJson
end

describe AutoJson do
  context "converts" do
    it { Empty.new.to_json.should eq "{}" }
    it { Empty.from_json("{}").should be_a(Empty) }
  end
end
