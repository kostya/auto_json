require "./spec_helper"

struct EnabledFields
  include AutoJson

  field :a, Int32, default: 10, serialize: false
  field :b, Int32, default: 11, json: false
  field :c, Int32, default: 12
end

struct FullyEmpty
  include AutoJson

  field :a, Int32, default: 10, json: false
  field :b, Int32, default: 11, json: false
end

struct DisabledField
  include AutoJson

  field :a, Int32?, json: false
end

struct DisabledFieldNilableDefault
  include AutoJson

  field :a, Int32?, json: false, default: 11
end

describe AutoJson do
  context "FullyEmpty" do
    it do
      f = FullyEmpty.new
      f.a.should eq 10
      f.b.should eq 11
      f.to_json.should eq %q<{}>
    end

    it do
      f = FullyEmpty.from_json(%q<{}>)
      f.a.should eq 10
      f.b.should eq 11
    end

    it do
      f = FullyEmpty.from_json(%q<{"a":111}>)
      f.a.should eq 10
      f.b.should eq 11
    end
  end

  context "EnabledFields" do
    it do
      f = EnabledFields.new
      f.a.should eq 10
      f.b.should eq 11
      f.c.should eq 12
      f.to_json.should eq %q<{"c":12}>
    end

    it do
      f = EnabledFields.from_json(%q<{}>)
      f.a.should eq 10
      f.b.should eq 11
      f.c.should eq 12
    end

    it do
      f = EnabledFields.from_json(%q<{"a":111,"c":112}>)
      f.a.should eq 10
      f.b.should eq 11
      f.c.should eq 112
    end
  end

  context "DisabledField" do
    it do
      f = DisabledField.new(10)
      f.a.should eq 10
      f.to_json.should eq %q<{}>
    end

    it do
      f = DisabledField.from_json(%q<{}>)
      f.a.should eq nil
    end

    it do
      f = DisabledField.from_json(%q<{"a":111}>)
      f.a.should eq nil
    end
  end

  context "DisabledFieldNilableDefault" do
    it do
      f = DisabledFieldNilableDefault.new(10)
      f.a.should eq 10
      f.to_json.should eq %q<{}>
    end

    it do
      f = DisabledFieldNilableDefault.from_json(%q<{}>)
      f.a.should eq 11
    end

    it do
      f = DisabledFieldNilableDefault.from_json(%q<{"a":111}>)
      f.a.should eq 11
    end
  end
end
