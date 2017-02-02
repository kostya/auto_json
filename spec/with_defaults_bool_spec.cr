require "./spec_helper"

struct WithDefaultsBoolTrue
  include AutoJson
  field :x, Bool, default: true
end

struct WithDefaultsBoolFalse
  include AutoJson
  field :x, Bool, default: false
end

describe "AutoJson" do
  context "WithDefaultsBoolTrue" do
    it { WithDefaultsBoolTrue.from_json(%q<{"x":true}>).x.should eq true }
    it { WithDefaultsBoolTrue.from_json(%q<{}>).x.should eq true }
    it { WithDefaultsBoolTrue.from_json(%q<{"x":null}>).x.should eq true }
    it { WithDefaultsBoolTrue.from_json(%q<{"x":false}>).x.should eq false }
  end

  context "WithDefaultsBoolFalse" do
    it { WithDefaultsBoolFalse.from_json(%q<{"x":false}>).x.should eq false }
    it { WithDefaultsBoolFalse.from_json(%q<{}>).x.should eq false }
    it { WithDefaultsBoolFalse.from_json(%q<{"x":true}>).x.should eq true }
    it { WithDefaultsBoolFalse.from_json(%q<{"x":null}>).x.should eq false }
  end
end
