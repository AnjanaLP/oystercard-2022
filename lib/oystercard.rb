class Oystercard
  MAX_BALANCE = 90
  MIN_FARE = 1

  attr_reader :balance, :entry_station

  def initialize
    @balance = 0
    @in_journey = false
  end

  def top_up(amount)
    raise "Cannot top up: £#{MAX_BALANCE} limit exceeded" if at_max_balance?(amount)
    increase_balance(amount)
  end

  def touch_in(station)
    raise "Cannot touch in: balance below £#{MIN_FARE}" if insufficent_balance?
    @entry_station = station
  end

  def touch_out
    deduct(MIN_FARE)
    @entry_station = nil
  end

  def in_journey?
    !entry_station.nil?
  end

  private

  def at_max_balance?(amount)
    balance + amount > MAX_BALANCE
  end

  def increase_balance(amount)
    @balance += amount
  end

  def deduct(amount)
    @balance -= amount
  end

  def insufficent_balance?
    balance < MIN_FARE
  end
end
