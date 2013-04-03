require_relative 'spec_helper'
require_relative '../lib/todo_list'
require_relative '../lib/exceptions'

describe TodoList do

  subject(:list)            { TodoList.new(db: database, social_network: social_network) }
  let(:database)            { stub }
  let(:item)                { Struct.new(:title,:description).new(title,description) }
  let(:title)               { "Shopping" }
  let(:description)         { "Go to the shop and buy toilet paper and toothbrush" }
  let(:status)              { false }
  let(:social_network)      { stub }

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
    stub(database).items_count { 1 }
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }
    stub(social_network).spam {true}

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).get_todo_item(0) { item }
    mock(database).completed_item?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).get_todo_item(0) { item }
    mock(database).completed_item?(0) { true }
    mock(database).complete_todo_item(0,false) { true }

    list.toggle_state(0)
    list.toggle_state(0)
  end

  it "should raise exception when changing item's state, if the item is nil" do
    expect{ list.toggle_state(1) }.to raise_error(Exception)
  end

  it "should fetch the first item from the DB" do
    stub(database).items_count { 1 }
    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item for the DB" do
    stub(database).items_count { 6 }

    mock(database).get_todo_item(5) { item }
    list.last.should == item

    mock(database).get_todo_item(5) { nil }
    list.last.should == nil
  end

  context "with empty title of the item" do
    let(:title)   { "" }

    it "should not add the item to the DB" do
      dont_allow(database).add_todo_item(item)
      list << item
    end  
  end

  context "with nil item" do
    let(:item)    { nil }

    it "should not add the item if it's nil" do
      dont_allow(database).add_todo_item(item)
      list << item 
    end

    it "should raise exception when changing item state, if the item is nil" do
      mock(database).get_todo_item(0) { item }
      expect{ list.toggle_state(0) }.to raise_error(Exception)
    end

  end

  context "with too short item title" do
    let(:title)    { "Do" }

    it "should not add the item if it's nil" do
      dont_allow(database).add_todo_item(item)
      list << item 
    end
  end

  context "with empty item describtion" do
    let(:describtion)   { "" }

    it "should persist an item with empty describtion" do
      stub(database).items_count { 1 }
      mock(database).add_todo_item(item) { true }
      mock(database).get_todo_item(0) { item }
      stub(social_network).spam {true}

      list << item
      list.first.should == item
    end

  end

  context "with nil social network" do
    let(:social_network)    { nil }

    it "doesn't spam social network when item is being added to list if social network is nil" do
      stub(database).items_count { 1 }
      mock(database).add_todo_item(item) { true }

      dont_allow(social_network).spam(item[:title] + " added!")
      list << item
    end
  end

  context "with provided social network" do

    it "spams social network when item is being added to list if social network is provided" do
      stub(database).items_count { 1 }
      mock(database).add_todo_item(item) { true }
      mock(social_network).spam(item[:title] + " added!") {true}

      list << item
      #it should be enough - mock determines, if this test passes or not - if spam method is called or not!
    end
  end








=begin
  subject(:list)            { TodoList.new(db: database, social_network: network) }
  let(:database)            { stub }
  let(:network)             { stub }
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
    mock(database).items_count { 1 }
    mock(database).add_todo_item(item) { true }
    mock(database).get_todo_item(0) { item }
    stub(network).notify { true }

    list << item
    list.first.should == item
  end

  it "should persist the state of the item" do
    mock(database).get_todo_item(0) { item }
    mock(database).todo_item_completed?(0) { false }
    mock(database).complete_todo_item(0,true) { true }
    mock(database).get_todo_item(0) { item }
    mock(database).todo_item_completed?(0) { true }
    mock(database).complete_todo_item(0,false) { true }

    list.toggle_state(0)
    list.toggle_state(0)
  end

  it "should raise exception when changing item's state, if the item is nil" do
    expect{ list.toggle_state(1) }.to raise_error(Exception)
  end


  it "should fetch the first item from the DB" do
    mock(database).get_todo_item(0) { item }
    stub(database).items_count { 1 }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
  end

  it "should fetch the last item from the DB" do
    stub(database).items_count { 1 }

    mock(database).get_todo_item(0) { item }
    list.first.should == item

    mock(database).get_todo_item(0) { nil }
    list.first.should == nil
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
    stub(database).items_count { 0 }
    list.first.should == nil
    list.last.should == nil
  end

  it "should raise an exception when changing the item state if the item is nil" do
    mock(database).get_todo_item(0) { nil }
    expect{ toggle_state(0) }.to raise_error(IllegalArgument)
  end

  #social spam
  context "with social network" do
  
    subject(:list) { TodoList.new(db: database, social_network: network) }
    let(:network) { stub }

    it "should notify a social network if an item is added to the list" do 
      mock(database).add_todo_item(item) { true }
      list << item
      stub(network).notify(item) { true }
    end

    it "should notify a social network if an item is completed" do
      mock(database).todo_item_completed?(0) { false }
      mock(database).complete_todo_item(0,true) { true }
      list.toggle_state(0)
      stub(network).notify(item) { true }
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
        stub(network).notify(item) { true }
      end
    end

    context "with title longer than 255 chars" do
      let(:title) { "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam ligula leo, imperdiet id aliquam at, blandit in nulla. Mauris at nulla tortor. Sed egestas elit non eros varius molestie. Sed tincidunt cursus rhoncus. Etiam nec justo urna. Fusce tempus convallis enim, vel gravida." } 

      it "should cut the title of the item when notifying the social network if it is longer than 255 chars - adding and completing" do 
        short_title = item[:title][0,254]
        mock(database).add_todo_item(item) { true }
        list << item
        stub(network).notify_short_title(item, short_title) { true }
      end
    end
  end
=end



end
