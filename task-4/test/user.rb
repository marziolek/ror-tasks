require_relative 'test_helper'
require_relative '../lib/user'

describe User do
  include TestHelper
  subject(:user)   { user = User.new(attributes) }
  let(:attributes) { { :name => name, 
                       :surname => surname, 
                       :email => email, 
                       :password => password, 
                       :failed_login_count => failed_login_count,
                       :terms_of_service => terms_of_service
                       } }

  let(:name) { "Marcin" }
  let(:surname) { "Ziolek" }
  let(:email) { "mar.ziolek@gmail.com" }
  let(:password) { "mypassword123" }
  let(:failed_login_count) { 0 }
  let(:terms_of_service) { true }

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

  context "with terms of service not accepted" do
    let(:terms_of_service) { false }
    it { should_not be_valid }
  end

  context "with queries" do
    it "should find user by name" do
      add_user
      User.find_by_name(name).count.should == 2 
    end

    it "should find user by email" do
      add_user
      User.find_by_email(email).email.should == "mar.ziolek@gmail.com" 
    end

    it "should find suspicious users" do
      add_user
      suspicious_users = user.find_suspicious
      suspicious_users.count.should == 2 
    end

    it "should group users with failed login count descending" do
      suspicious_users = user.find_suspicious
      suspicious_users.count.should == 2
      suspicious_users[0].failed_login_count.should == 5
      suspicious_users[1].failed_login_count.should == 3
    end
    
    it "should authenticate user" do
      User.new(email: 'marcin.ziolek@gmail.com', password: 'mypassword123').authenticate.should == true
    end
  end

  protected
  def add_user
    user.save
  end
end
