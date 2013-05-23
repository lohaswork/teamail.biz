# encoding: utf-8
require 'spec_helper'

describe "LoginPage" do
  before { visit '/login' }

  describe "GET /login" do
    it "See login page" do
      page.should have_button('登陆')
    end
  end
end
