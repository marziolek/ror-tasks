require_relative 'test_helper'
require_relative '../lib/todo_list'

describe TodoList do
  include TestHelper

  subject(:todo_list)           { todo_list = TodoList.new(attributes) }
  let(:attributes)              { {:id => id,
                                   :title => title,
                                   :user_id => user_id} }
  let(:title)                   { "My title" }
  let(:user_id)                 { 1 }
  let(:id)                      { 1 }

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
  
  context "with invalid, non integer id user" do
    let(:user_id) { "a" } 
    it { should_not be_valid }
  end

  context "with queries" do
    let(:prefix) { "My ti" }
    it "should find list by prefix of the title" do
      add_todo_list
      TodoList.where("title LIKE ?", "%#{prefix}%").all.count.should == 1
    end 

    it "should find all lists that belongs to user" do
      add_todo_list
      TodoList.where("user_id = ?", user_id).count.should == 1
    end

    it "should find list by id and load its items" do
      add_todo_list
      list = TodoList.includes(:todo_items).where("id = ?", id)
    end
  end

  protected
  def add_todo_list
    todo_list.save
  end
end
