class Oystercard
  MAX_BALANCE = 90

  attr_reader :balance

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    raise "Cannot top up: £#{MAX_BALANCE} limit exceeded" if at_max_balance?(amount)
    increase_balance(amount)
  end

  def deduct(amount)
    @balance -= amount
  end

  def touch_in
    @in_journey = true
  end

  def touch_out
    @in_journey = false
  end

  def in_journey?
    @in_journey
  end

  private

  def at_max_balance?(amount)
    balance + amount > MAX_BALANCE
  end

  def increase_balance(amount)
    @balance += amount
  end
end
