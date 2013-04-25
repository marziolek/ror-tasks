require_relative 'test_helper'
require_relative '../../lib/exceptions'
require_relative '../../lib/wallet'

#check devblog.avdi.org -> cast about acceptance tests

describe "E-wallet" do
  include WalletTestHelper

  before(:each) do
    set_money_balance :pln => 100, :eur => 10
    set_stock_balance :abc => 100, :eat => 10
  end

  specify "adding money" do
    add_money(:eur, 50)
    get_money_balance(:pln).should == 100
    get_money_balance(:eur).should == 60
  end 

  specify "exchange from PLN to EUR without limit" do
    set_exchange_rate [:pln, :eur] => 0.25
    exchange_money(:pln, :eur)
    get_money_balance(:pln).should == 0
    get_money_balance(:eur).should == 35
  end

  specify "exchange from PLN to EUR with limit" do
    set_exchange_rate [:pln, :eur] => 0.25
    exchange_money_with_limit(:pln, :eur, 50)
    get_money_balance(:pln).should == 50
    get_money_balance(:eur).should == 22.5
  end

  specify "buying stocks" do 
    set_stock_price :eat => 5
    buy_stock(:eat, 15)
    get_stock_balance(:abc).should == 100
    get_stock_balance(:eat).should == 25
    get_money_balance(:pln).should == 25
  end

  specify "selling stocks without limit" do 
    set_stock_price :abc => 2
    sell_stock(:abc)
    get_stock_balance(:abc).should == 0
    get_money_balance(:pln).should == 300
  end

  context "with not enough amount of money/stocks" do
    specify "exchange from EUR to PLN without limit" do
      set_exchange_rate [:eur, :pln] => 4
      exchange_money(:eur, :pln)
      get_money_balance(:pln).should == 140
      get_money_balance(:eur).should == 0
    end

    specify "exchange from EUR to PLN with limit" do
      set_exchange_rate [:eur, :pln] => 4
      exchange_money_with_limit(:eur, :pln, 50)
      get_money_balance(:pln).should == 140
      get_money_balance(:eur).should == 0
    end

    specify "buying stocks" do 
      set_stock_price :eat => 50
      buy_stock(:eat, 15)
      get_stock_balance(:abc).should == 100
      get_stock_balance(:eat).should == 12
      get_money_balance(:pln).should == 0
    end
  end
end
