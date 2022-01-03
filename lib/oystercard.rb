require_relative 'journey'

class Oystercard
  MAX_BALANCE = 90


  attr_reader :balance, :journeys, :current_journey
  def initialize(journey_class = Journey)
    @balance = 0
    @journeys = []
    @in_journey = false
    @journey_class = journey_class
  end

  def top_up(amount)
    raise "Cannot top up: £#{MAX_BALANCE} limit exceeded" if at_max_balance?(amount)
    increase_balance(amount)
  end

  def touch_in(station)
    raise "Cannot touch in: balance below £#{Journey::MIN_FARE}" if insufficent_balance?
    set_current_journey(station)
    add_current_journey
    deduct(6)
  end

  def touch_out(station)
    top_up(6) if current_journey
    set_current_journey
    current_journey.end(station)
    add_current_journey
    deduct(current_journey.fare)
    @current_journey = nil
  end

  def complete?(station)
    entry_station && station
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
    balance < Journey::MIN_FARE
  end

  def add_current_journey
    journeys << current_journey unless journeys.include?(current_journey)
  end

  def set_current_journey(station = nil)
    if station
      @current_journey = @journey_class.new(station)
    else
      @current_journey ||= @journey_class.new
    end
  end
end
