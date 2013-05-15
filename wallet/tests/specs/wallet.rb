require_relative '../../lib/e-wallet/wallet'
require_relative '../../lib/e-wallet/money'
require_relative '../../lib/e-wallet/exceptions'
require_relative 'spec_helper'

describe Wallet do
  subject(:wallet)              { Wallet.new(Money("100"), :pln) }
  let(:possible_currencies)     { :pln  } #should be choice between eg. :pln, :eur
  #maybe just :currency
  let(:amount)                  { Money("100") }

  it "should throw an exception when wrong name of currency is given" do
    expect{ Wallet.new("100", :abc)  }.to raise_error(IllegalArgument)
  end

  it "should throw an exception when amount is less than 0 name of currency is given" do
    expect{ Wallet.new("-100", :abc)  }.to raise_error(IllegalArgument)
  end

  it "should return current money amount in wallet" do 
    wallet.balance.should == Money("100")
  end
end
