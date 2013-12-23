require 'spec_helper'

describe Topic do

  subject (:topic){ Topic.new(:title=>"test title") }

  it { should respond_to :title }
  it { should respond_to :email_title }
  it { should be_valid }

  describe "when missing title" do
    before { topic.title = "" }
    it { should_not be_valid }
  end
end
