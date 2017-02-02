require "./spec_helper"

struct Bool1
  include AutoJson
  field :x, Bool
end

struct Nil1
  include AutoJson
  field :x, Nil
end

describe "AutoJson" do
  context "Bool1" do
    it { Bool1.from_json(%q<{"x":true}>).x.should eq true }
    it { Bool1.new(true).to_json.should eq %q<{"x":true}> }
    it { Bool1.from_json(%q<{"x":false}>).x.should eq false }
    it { Bool1.new(false).to_json.should eq %q<{"x":false}> }
  end

  context "Nil1" do
    it { Nil1.from_json(%q<{"x":null}>).x.should eq nil }
    it { Nil1.from_json(%q<{}>).x.should eq nil }
    it { Nil1.new(nil).to_json.should eq %q<{}> }
  end
end
