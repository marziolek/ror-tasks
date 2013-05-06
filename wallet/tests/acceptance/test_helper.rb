module WalletTestHelper
  def set_money_balance(accounts)
    @accounts ||= []
    accounts.each do |currency, value|
      @accounts << Account.new(currency,value)
    end
  end

  def set_stock_balance(accounts)
    @accounts ||= []
    accounts.each do |stock, value|
      @accounts << Account.new(stock,value)
    end
  end

  def add_money(currency, amount)
    adder = Adder.new(find_account(currency))
    adder.add(amount)
  end

  def find_money(currency)
    @accounts.find{ |a| a.currency == currency }
  end

  def find_stock(name)
    @accounts.find{ |a| a.name == name }
  end

  def get_money_balance(currency)
    find_account(currency).balance
  end

  def get_stock_balance(stock)
    find_account(stock).balance
  end

  def exchange_money(source_currency,target_currency,limit)
    @limit ||= get_balance(source_currency)
    exchanger = Exchanger.new(find_account(source_currency), find_account(target_currency), find_rate(source_currency, target_currency))
    exchanger.exchange(limit)
  end

  def set_exchange_rate(rates)
    @rates ||= []
    rates.each do |(source,target), value|
    @rates << ExchangeRate.new(source,target,value)
    end
  end

  def set_stock_price(stock_price)
    @stock_price ||= []
    stock_price.each do |name,price|
      @stock_price << StockPrice.new(name,price)
    end
  end

  def buy_stock(name,amount)
    stocker = Stocker.new(find_stock_price(name))
    stocker.buy(amount)
  end

  def sell_stock(name,amount)
    @amount ||= get_stock_balance(name)
    stocker = Stocker.new(find_account(name), find_stock_rate(name)) 
    stocker.sell(amount)
  end 
end 
