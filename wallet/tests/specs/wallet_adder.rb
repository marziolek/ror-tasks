require_relative '../../lib/e-wallet/wallet_adder'
require_relative '../../lib/e-wallet/money'
require_relative '../../lib/e-wallet/exceptions'
require_relative 'spec_helper'

describe WalletAdder do
  subject(:adder)      { WalletAdder.new(:bank_account, :wallet) }
  let(:bank_account)   { mock }
  let(:wallet)         { mock }

  context "with bank account in PLN or EUR" do
    context "with second argument missing" do
      it "should not add money" do
        supplier = WalletAdder.new(:bank_account)
        supplier.wallet.should == nil
      end
    end
    
    it "should add" do 

    end

  end
end
