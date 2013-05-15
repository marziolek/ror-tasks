require_relative '../../lib/e-wallet/wallet_adder'
require_relative '../../lib/e-wallet/money'
require_relative '../../lib/e-wallet/exceptions'
require_relative 'spec_helper'

describe WalletAdder do
  subject(:adder)      { WalletAdder.new(:bank_account, :wallet) }
  let(:bank_account)   { mock }
  let(:wallet)         { mock }
#  let(:money_from_bank){ Money("100") }
#  let(:currency)       { :pln }


  it "should add money to wallet" 
#  do 
#    supplier = WalletAdder.new(:bank_account, :wallet)
#    supplier.wallet  
#  end

end
