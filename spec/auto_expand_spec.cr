require "./spec_helper"

class AutoExpand
  include AutoJson
  field :x, Int32
end

class AutoExpand
  field :y, String
end

describe AutoConstructor do
  context "auto expand class" do
    it do
      a = AutoExpand.from_json(%q<{"x":1,"y":"bla"}>)
      a.x.should eq 1
      a.y.should eq "bla"
    end
  end
end
