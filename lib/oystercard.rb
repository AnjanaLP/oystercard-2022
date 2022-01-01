class Oystercard
  MAX_BALANCE = 90

  attr_reader :balance

  def initialize
    @balance = 0
  end

  def top_up(amount)
    raise "Cannot top up: £#{MAX_BALANCE} limit exceeded" if at_max_balance?(amount)
    increase_balance(amount)
  end

  private

  def at_max_balance?(amount)
    balance + amount > MAX_BALANCE
  end

  def increase_balance(amount)
    @balance += amount
  end
end
