require 'spec_helper'

describe Tag do

  subject (:tag){ Tag.new(:name=>"Tag_名字-1号") }

  it { should respond_to :color }
  it { should respond_to :name }
  it { should respond_to :organization_id }
  it { should be_valid }

  describe "when missing name" do
    before { tag.name = nil }
    it { should_not be_valid }
  end

  describe "when name format is invalid" do
    it "should be invalid" do
      names = ["has space", "has[", "has]"]
      names.each do |invalid_name|
        tag.name = invalid_name
        expect(tag).not_to be_valid
      end
    end
  end

end
