require_relative 'journey_log'

class Oystercard
  MAX_BALANCE = 90
  MIN_BALANCE = 6

  attr_reader :balance, :journey_log

  def initialize(journey_log = JourneyLog.new)
    @balance = 0
    @journey_log = journey_log
  end

  def top_up(amount)
    raise "Cannot top up: £#{MAX_BALANCE} limit exceeded" if at_max_balance?(amount)
    @balance += amount
  end

  def touch_in(station)
    raise "Cannot touch in: balance below £#{MIN_BALANCE}" if insufficent_balance?
    deduct(journey_log.start(station))
  end

  def touch_out(station)
    deduct(journey_log.finish(station))
    top_up(journey_log.refund_amount)
  end

  private

  def at_max_balance?(amount)
    balance + amount > MAX_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def insufficent_balance?
    balance < MIN_BALANCE
  end
end
