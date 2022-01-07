require_relative 'journey'

class JourneyLog
  REFUND = 6

  attr_reader :current_journey

  def initialize(journey_class = Journey)
    @journeys = []
    @journey_class = journey_class
  end

  def start(station)
    set_current_journey(station)
    add(current_journey)
    current_journey.fare
  end

  def finish(station)
    set_current_journey
    add(current_journey.end(station))
    @current_journey = nil
    last_journey.fare
  end

  def refund_amount
    last_journey.complete? ? REFUND : 0
  end

  def journeys
    @journeys.dup
  end

  private

  attr_reader :journey_class

  def set_current_journey(station = nil)
    if station
      @current_journey = journey_class.new(station)
    else
      @current_journey ||= journey_class.new
    end
  end

  def add(journey)
    @journeys << journey unless journeys.include?(journey)
  end

  def last_journey
    journeys.last
  end
end
