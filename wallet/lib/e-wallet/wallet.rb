class Wallet 
  
  def initialize(amount, currency)
    if [:pln,:eur].include? currency
      @currency = currency
    else
      raise IllegalArgument
    end
    
    if amount >= 0
      @amount = amount
    else
      raise IllegalArgument
    end
  end

  def balance 
    @amount
  end
end
