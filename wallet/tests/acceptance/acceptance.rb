require_relative 'test_helper'

#ceck devblog.avdi.org -> cast about acceptance tests

describe "E-wallet" do
  include WalletTestHelper

  context "user with two bank accounts EUR and PLN" do
    specify "exchange of all money from the EUR account" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln
      get_balance(:eur).should == "0.00"
      get_balance(:pln).should == "415.00"
    end

    specify "exchange of money with specified amount of EUR" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln, :eur => "50.00"
      get_balance(:eur).should == "50.00"
      get_balance(:pln).should == "207.50"
    end

    specify "exchange of money with specified amount of PLN" do
      set_balance :eur => "100", :pln => "0"
      set_exchange_rate [:eur,:pln] => "4.15"
      exchange_money :eur, :pln, :pln => "200.03"
      get_balance(:eur).should == "51.80"
      #The resulting amount of target currency should be no-less than the specified
      #value, if the exact value cannot be obtained.
      get_balance(:pln).should == "200.03"
    end
    
    specify "adding money to wallet" do
      set_balance :pln => "100", :eur => "10"
      add_money(:eur, "50")
      get_money_balance(:pln).should == "100.00"
      get_money_balance(:eur).should == "60.00"
    end 
  end

  context "operations connected with stocks" do
    specify "buying stocks" do 
      set_stock_balance :ibm => 100, :rmf => 10
      set_balance :pln => "100", :eur => "10"
      set_stock_price :rmf => 5
      buy_stock(:rmf, 15)
      get_stock_balance(:ibm).should == 100
      get_stock_balance(:rmf).should == 25
      get_money_balance(:pln).should == "25.00"
      get_money_balance(:eur).should == "10.00"
    end

    specify "selling stocks" do 
      set_stock_balance :ibm => 100, :rmf => 10
      set_balance :pln => "100", :eur => "10"
      set_stock_price :ibm => "2"
      sell_stock(:ibm)
      get_stock_balance(:ibm).should == 0
      get_money_balance(:pln).should == "300.00"
      get_money_balance(:eur).should == "10.00"
    end
  end
end
