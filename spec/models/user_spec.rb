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

  describe ".authentication" do
    before do
      user.active_status = 1
      user.save
    end
    subject (:result){ User.authentication(@email, @password) }

    it "when a valid user" do
      @email = "user@example.com"
      @password = "password"
      expect(result).to be_a User
    end

    it "when password is not present" do
      @email = "user@example.com"
      expect{result}.to raise_error(ValidationError)
    end

    it "when password is incorrect" do
      @email = "user@example.com"
      @password = "wrongpassword"
      expect{result}.to raise_error(ValidationError)
    end

    it "when use a wrong email" do
      @email = "wrong@example.com"
      @password = "password"
      expect{result}.to raise_error(ValidationError)
    end

    it "when the user is not active" do
      user.update_attribute(:active_status, false)
      @email = "user@example.com"
      @password = "password"
      expect{result}.to raise_error(ValidationError)
    end
  end
end
