require 'spec_helper'

describe "Topics request" do
  let(:user) { create(:normal_user) }
  let :access_token do
    url = "/api/v1/oauth/token?" + {:email => user.email, :password => user.password, :grant_type => 'password'}.to_query
    post url
    JSON.parse(response.body)["access_token"]
  end

  describe "personal topics" do
    it "should get personal topics" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=all&page=1&per_page=2"
      body = JSON.parse(response.body)
      body["topics"].size.should == 2
      body["total_count"].should == 10
      topic = body["topics"][1]
      %w(id creator title update_at has_attachments read_status tags).each do |key|
        topic.should have_key key
      end
    end

    it "should get the error message when missing params page" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=all&per_page=2"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "page is missing"
    end

    it "should get the error message when pass invalid params page" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=all&per_page=2&page=not_number"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "page is invalid"
    end

    it "should get the error message when missing params per_page" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=all&page=2"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "per_page is missing"
    end

    it "should get the error message when pass invalid params per_page" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=all&page=2&per_page=not_number"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "per_page is invalid"
    end

    it "should get the error message when missing params mailbox_type" do
      get "/api/v1/topics/personal?access_token=#{access_token}&page=1&per_page=2"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "mailbox_type is missing"
    end

    it "should get the error message when pass invalid params mailbox_type" do
      get "/api/v1/topics/personal?access_token=#{access_token}&mailbox_type=invalid&page=1&per_page=2"
      body = JSON.parse(response.body)
      body.should have_value "Bad Request"
      body.should have_value "mailbox_type does not have a valid value"
    end

  end

  describe "organization topics" do
    it "should get organization topics" do
      get "/api/v1/topics/organization?access_token=#{access_token}&page=1&per_page=2"
      body = JSON.parse(response.body)
      body["topics"].size.should == 2
      body["total_count"].should == 10
      topic = body["topics"][1]
      %w(id creator title update_at has_attachments read_status tags).each do |key|
        topic.should have_key key
      end
    end
  end

end
