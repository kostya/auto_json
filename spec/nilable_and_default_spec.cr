require "./spec_helper"

class Nilable1
  include AutoJson
  field :x, Int32?, default: 1
end

class Nilable2
  include AutoJson
  field :x, Int32?, default: nil
end

class Nilable3
  include AutoJson
  field :x, Bool?, default: false
end

class Nilable4
  include AutoJson
  field :x, Bool?, default: true
end

class Nilable5
  include AutoJson
  field :x, Bool?, default: nil
end

describe AutoJson do
  context "Nilable1" do
    it { Nilable1.from_json(%q<{"x":2}>).x.should eq 2 }
    it { Nilable1.from_json(%q<{}>).x.should eq 1 }
    it { Nilable1.from_json(%q<{"x":null}>).x.should eq nil }
  end

  context "Nilable2" do
    it { Nilable2.from_json(%q<{"x":2}>).x.should eq 2 }
    it { Nilable2.from_json(%q<{}>).x.should eq nil }
    it { Nilable2.from_json(%q<{"x":null}>).x.should eq nil }
  end

  context "Nilable3" do
    it { Nilable3.from_json(%q<{"x":true}>).x.should eq true }
    it { Nilable3.from_json(%q<{"x":false}>).x.should eq false }
    it { Nilable3.from_json(%q<{"x":null}>).x.should eq nil }
    it { Nilable3.from_json(%q<{}>).x.should eq false }
  end

  context "Nilable4" do
    it { Nilable4.from_json(%q<{"x":true}>).x.should eq true }
    it { Nilable4.from_json(%q<{"x":false}>).x.should eq false }
    it { Nilable4.from_json(%q<{"x":null}>).x.should eq nil }
    it { Nilable4.from_json(%q<{}>).x.should eq true }
  end

  context "Nilable5" do
    it { Nilable5.from_json(%q<{"x":true}>).x.should eq true }
    it { Nilable5.from_json(%q<{"x":false}>).x.should eq false }
    it { Nilable5.from_json(%q<{"x":null}>).x.should eq nil }
    it { Nilable5.from_json(%q<{}>).x.should eq nil }
  end
end
