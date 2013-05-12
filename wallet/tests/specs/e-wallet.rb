#require_relative '../../lib/e-wallet'
require_relative '../../lib/e-wallet/exchanger'
require_relative '../../lib/e-wallet/calculator'
require_relative '../../lib/e-wallet/money'
require_relative 'spec_helper'

describe Exchanger do

  subject(:exchanger)   { exchanger =
                          CurrencyExchanger.new(source_account,target_account,rate)
                          exchanger.calculator = calculator
                          exchanger
  }
  let(:source_account) { stub!.balance { source_initial_amount }.subject }
  let(:target_account) { stub!.balance { target_initial_amount }.subject }
  let(:rate) { Money("4.25") }
  let(:source_initial_amount)   { Money("100") }
  let(:target_initial_amount)   { Money("0") }

  context "without a limit specified" do
    let(:source_final_amount)   { Money("0") }
    let(:target_final_amount)   { Money("415") }

    it "should exchange all money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)
      mock(calculator).compute_target_amount(source_initial_amount,rate) { target_final_amount }

      exchanger.exchange()
    end
  end

  context "with a limit specified for the source currency" do
    let(:source_final_amount)   { Money("50") }
    let(:target_final_amount)   { Money("205.75") }
    let(:limit)                 { Money("50") }

    it "should exchange the specified amount of money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)

      exchanger.exchange(:source => limit)
    end
  end

  context "with a limit specified for the target currency" do
    let(:source_final_amount)   { Money("51.80") }
    let(:target_final_amount)   { Money("200.03") }
    let(:limit)                 { Money("200") }

    it "should exchange the specified amount of money" do
      mock(source_account).withdraw(source_initial_amount)
      mock(target_account).deposit(target_final_amount)

      exchanger.exchange(:target => limit)
    end
  end

end
