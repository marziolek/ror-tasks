require_relative 'test_helper'
require_relative '../lib/todo_list'

describe TodoList do
  include TestHelper

  subject(:todo_list)           { todo_list = TodoList.new(attributes) }
  let(:attributes)              { {:title => title,
                                   :user_id => user_id} }
  let(:title)                   { "My title" }
  let(:user_id)                 { 1 }
  
  it "should save with valid attributes" do
    todo_list.save.should == true
  end

  context "with empty title" do
    let(:title) { "" }
    it { should_not be_valid }
  end
  
  context "with no user" do
    let(:user_id) { nil } 
    it { should_not be_valid }
  end
  
  context "with invalid, non integer id, user" do
    let(:user_id) { "a" } 
    it { should_not be_valid }
  end
end
