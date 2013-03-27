require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do
  subject(:list)            { TodoList.new(db: database) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }

  it "should raise an exception if the database layer is not provided" do
    expect{ TodoList.new(db: nil) }.to raise_error(IllegalArgument)
  end

  it "should be empty if there are no items in the DB" do
    stub(database).items_count { 0 }
    list.should be_empty
  end

  it "should not be empty if there are some items in the DB" do
    stub(database).items_count { 1 }
    list.should_not be_empty
  end

  it "should return its size" do
    stub(database).items_count { 6 }

    list.size.should == 6
  end

  it "should persist the added item" do
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0,false) { true }

    list.toggle_state(0)
    list.toggle_state(0)
  end

  it "should fetch the first item from the DB" do
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  context "with nil item" do
    let(:item) { nil }
    
    it "should not accept nil item" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end

  context "with empty description" do
    let(:description) { "" }

    it "should not accept an item with missing description" do
      dont_allow(database).add_todo_item(item)

      list << item
    end
  end
  
  it "should return nil for first and last item if DB is empty" do 
    mock(database).empty? { true }
    list.first.should == nil
    list.last.should == nil
  end

  it "should raise an exception when changing the item state if the item is nil" do
    mock(database).get_todo_item(0) { nil }
    expect{ mock(database).complete_todo_item(0, true) }.to raise_error(IllegalArgument)
  end

  #social spam
  
  context "with social network" do
    subject(:list) { TodoList.new(db: database, social_network: network) }
    let(:network) { mock }

    it "should notify a social network if an item is added to the list" do 
      mock(database).add_todo_item(item) { true }
      list << item
      mock(network).notify(item) { true }
    end

    it "should notify a social network if an item is completed" do
      mock(database).todo_item_completed?(0) { false }
      mock(database).complete_todo_item(0,true) { true }
      list.toggle_state(0)
      mock(network).notify(item) { true }
    end
    
    context "with empty title" do
      let(:title) { "" }
      
      it "should not notify a social network if the title of the item is missing" do
        dont_allow(network).notify(item)
        list << item 
      end
    end
    
    context "with missing body of the item" do
      let(:body) { "" }
      
      it "should notify a social network if the body of the item is missing" do
        mock(database).add_todo_item(item) { true }
        list << item
        mock(network).notify(item) { true }
      end
    end

    context "with title longer than 255 chars" do
      let(:title) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ligula leo, imperdiet id aliquam at, blandit in nulla. Mauris at nulla tortor. Sed egestas elit non eros varius molestie. Sed tincidunt cursus rhoncus. Etiam nec justo urna. Fusce tempus convallis enim, vel gravida." } 

      it "should cut the title of the item when notifying the social network if it is longer than 255 chars - adding and completing" do 
        short_title = item[:title][0,254]
        mock(database).add_todo_item(item) { true }
        list << item
        mock(network).notify_short_title(item, short_title) { true }
      end
    end
  end
end
