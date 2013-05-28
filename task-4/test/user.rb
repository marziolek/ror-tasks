require_relative 'test_helper'
require_relative '../lib/user'

describe User do
  include TestHelper
  subject(:user)   { user = User.new(attributes) }
  let(:attributes) { { :name => name, 
                       :surname => surname, 
                       :email => email, 
                       :password => password, 
                       :failed_login_count => failed_login_count
                       } }

  let(:name) { "Marcin" }
  let(:surname) { "Ziolek" }
  let(:email) { "mar.ziolek@gmail.com" }
  let(:password) { "mypassword123" }
  let(:failed_login_count) { 0 }
  let(:terms_of_service) { 1 } #still don't know how to test it?!

  it "should save with valid attributes" do
    user.save.should == true
  end

  context "with empty name" do
    let(:name) { "" }
    it { should_not be_valid }
  end

  context "with too long name" do
    let(:name) { "i"*21 }
    it { should_not be_valid }
  end

  context "with empty surname" do
    let(:surname) { "" }
    it { should_not be_valid }
  end

  context "with too long surname" do
    let(:surname) { "i"*31 }
    it { should_not be_valid }
  end

  context "with empty email" do
    let(:email) { "" }
    it { should_not be_valid }
  end

  context "with not valid email" do
    let(:email) { ".mar@ziolek.@$gmailcom" }
    it { should_not be_valid }
  end

  context "with empty password" do
    let(:password) { "" }
    it { should_not be_valid }
  end

  context "with too short password" do
    let(:password) { "mypass" }
    it { should_not be_valid }
  end

  context "with empty failed login count" do
    let(:failed_login_count) { "" }
    it { should_not be_valid }
  end

  context "with non-integer value in failed login count" do
    let(:failed_login_count) { "iii" }
    it { should_not be_valid }
  end

#  context "with terms of service not accepted" do
#    let(:terms_of_service) { 0 }
#    it { should_not be_valid }
#  end
end
