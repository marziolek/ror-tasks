require_relative '../../lib/e-wallet/wallet'
require_relative '../../lib/e-wallet/money'
require_relative '../../lib/e-wallet/exceptions'
require_relative 'spec_helper'

describe Wallet do
  subject(:wallet)      { Wallet.new(:amount, :currency) }

end
