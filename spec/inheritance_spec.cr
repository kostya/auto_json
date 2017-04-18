require "./spec_helper"

class AutoInherit1
  include AutoJson
  field :x, Int32
end

class AutoInherit2 < AutoInherit1
  field :y, String

  def xy
    {x, y}
  end
end

class AutoInherit3 < AutoInherit2
  field :z, String

  def xyz
    {x, y, z}
  end
end

class AutoInherit31 < AutoInherit2
  field :z, Int32

  def xyz
    {x, y, z}
  end
end

class AutoInherit32 < AutoInherit2
  field :zz, String

  def xyz
    {x, y, zz}
  end
end

class AutoInherit4 < AutoInherit3
  field :d, Int32

  def xyzd
    {x, y, z, d}
  end
end

describe AutoConstructor do
  it { AutoInherit1.new(1).to_json.should eq %q<{"x":1}> }
  it { AutoInherit1.from_json(%q<{"x":1}>).x.should eq 1 }

  it { AutoInherit2.new(1, "2").to_json.should eq %q<{"x":1,"y":"2"}> }
  # it { AutoInherit2.from_json(%q<{"x":1,"y":"2"}>).xy.should eq({1, "2"}) }

  it { AutoInherit3.new(1, "2", "z").to_json.should eq %q<{"x":1,"y":"2","z":"z"}> }
  # it { AutoInherit3.from_json(%q<{"x":1,"y":"2","z":"z"}>).xyz.should eq({1, "2", "z"}) }

  it { AutoInherit31.new(1, "2", 3).to_json.should eq %q<{"x":1,"y":"2","z":3}> }
  # it { AutoInherit31.from_json(%q<{"x":1,"y":"2","z":3}>).xyz.should eq({1, "2", 3}) }

  it { AutoInherit32.new(1, "2", "z").to_json.should eq %q<{"x":1,"y":"2","zz":"z"}> }
  # it { AutoInherit32.from_json(%q<{"x":1,"y":"2","zz":"z"}>).xyz.should eq({1, "2", "z"}) }

  it { AutoInherit4.new(1, "2", "z", 2).to_json.should eq %q<{"x":1,"y":"2","z":"z","d":2}> }
  # it { AutoInherit4.from_json(%q<{"x":1,"y":"2","z":"z","d":2}>).xyzd.should eq({1, "2", "z", 2}) }
end
