require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    described_class.new(
      name: "Carter Lopez", 
      email: "carter_lopez@hotmail.com", 
      password: "jubilee", 
      password_confirmation: "jubilee"
    )
  }

  describe "Validations" do
    it "validates with valid data" do
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end

    it "does not validate without name" do
      subject.name = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Name can't be blank")
    end


    it "does not validate without an email" do
      subject.email = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email can't be blank")
    end

    it "does not validate without pasword" do
      subject.password = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password can't be blank")
    end

    it "does not validate without pasword confirmation" do
      subject.password_confirmation = nil
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation can't be blank")
    end

    it "does not validate when password and password_confirmation do not match" do
      subject.password_confirmation = "instruction"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password confirmation doesn't match Password")
    end

    it "does not validate when email isn't unique" do
      User.create(
        name: "Cartiera Lopez", 
        email: "carter_lopez@hotmail.com", 
        password: "ajubilee", 
        password_confirmation: "ajubilee"
      )
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Email has already been taken")
    end

    it "does not validate when password is shorter than 5 characters" do
      subject.password = "pass"
      subject.password_confirmation = "pass"
      expect(subject).to_not be_valid
      expect(subject.errors.full_messages).to include ("Password is too short (minimum is 5 characters)")
    end

    it "validates when password is exactly 5 characters" do
      subject.password = "passa"
      subject.password_confirmation = "passa"
      expect(subject).to be_valid
      expect(subject.errors.full_messages).to be_empty
    end
  end

  describe '.authenticate_with_credentials' do

    before(:each) do
      subject.save!
    end

    it "works with valid credentials" do
      test_user = User.authenticate_with_credentials(subject.email, subject.password)
      expect(test_user).to eq subject
    end

    it "doesn't work with incorrect password" do
      test_user = User.authenticate_with_credentials(subject.email, "wrong")
      expect(test_user).to eq nil
    end

    it "doesn't work with incorrect email" do
      test_user = User.authenticate_with_credentials("wrong@error.com", subject.password)
      expect(test_user).to eq nil
    end

    it "works with correct email in a different case" do
      test_user = User.authenticate_with_credentials("CARTER_Lopez@hotmail.com", subject.password)
      expect(test_user).to eq subject
    end

    it "works with whitespace before email address" do
      test_user = User.authenticate_with_credentials(" " + subject.email, subject.password)
      expect(test_user).to eq subject
    end

  end

end