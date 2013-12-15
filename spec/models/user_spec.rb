require 'spec_helper'

describe User do

  subject (:user){ User.new(email: "user@example.com", password: "password") }

  it "create a valid user" do
    expect(user).to respond_to(:email)
    expect(user).to respond_to(:password)
    expect(user).to be_valid
  end

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        expect(user).not_to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = user.dup
      user_with_same_email.save
    end
    it { should_not be_valid }
  end

  describe "when password is less than 6 characters" do
    before { user.password = "123" }
    it { should_not be_valid }
  end

  describe "when name contains white space in the middle" do
    before { user.name = "ab cd" }
    it { should_not be_valid }
  end

  describe "when name is longer than 12 characters" do
    before { user.name = "a"*13 }
    it { should_not be_valid }
  end

  describe "when name is valid" do
    before { user.name = "abcd" }
    it "create a valid user" do
      expect(user).to respond_to(:name)
      expect(user).to be_valid
    end
  end
end
