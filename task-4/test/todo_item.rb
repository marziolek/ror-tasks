require_relative 'test_helper'
require_relative '../lib/todo_item'

describe TodoItem do
  include TestHelper

  subject(:todo_item)           { todo_item = TodoItem.new(attributes) }
  let(:attributes)              { {:title => title,
                                   :description => description,
                                   :todo_list_id => todo_list_id}}#,
#                                   :date_due => date_due} }
  let(:title)                   { "My todo item title" }
  let(:description)             { "This is my description shorter than 255 characters" }
  let(:todo_list_id)            { 1 }
  #let(:date_due)                { "28/05/2013" }
  #dont know how to let/test date  
 
  it "should save with valid attributes" do
    todo_item.save.should == true
  end

  context "with empty title" do
    let(:title) { "" }
    it { should_not be_valid }
  end
  
  context "with too short title" do
    let(:title) { "a"*3 }
    it { should_not be_valid }
  end
  
  context "with too long title" do
    let(:title) { "a"*31 }
    it { should_not be_valid }
  end
  
  context "with empty description" do
    let(:description) { "" }
    it { should be_valid }
  end
  
  context "with too long description" do
    let(:description) { "a"*256 }
    it { should_not be_valid }
  end
  
  context "with no todo list" do
    let(:todo_list_id) { nil } 
    it { should_not be_valid }
  end
  
  context "with invalid, non integer id, user" do
    let(:todo_list_id) { "a" } 
    it { should_not be_valid }
  end
end
