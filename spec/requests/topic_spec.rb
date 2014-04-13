require 'spec_helper'

describe "Topics request" do
  let(:user) { create(:normal_user) }
  before do
    url = "/api/v1/oauth/token?" + {:email => user.email, :password => user.password, :grant_type => 'password'}.to_query
    post url
    @access_token = JSON.parse(response.body)["access_token"]
  end

  it "get personal topics" do
    get "/api/v1/topics/personal?access_token=#{@access_token}&mailbox_type=all&page=1&per_page=2"
    body = JSON.parse(response.body)
    body["topics"].size.should == 2
    body["total_count"].should == 10
    topic = body["topics"][1]
    %w(id creator title update_at has_attachments read_status tags).each do |key|
      topic.should have_key key
    end
  end

  it "get organization topics" do
    get "/api/v1/topics/organization?access_token=#{@access_token}&page=1&per_page=2"
    body = JSON.parse(response.body)
    body["topics"].size.should == 2
    body["total_count"].should == 10
    topic = body["topics"][1]
    debugger
    %w(id creator title update_at has_attachments read_status tags).each do |key|
      topic.should have_key key
    end
  end
end
