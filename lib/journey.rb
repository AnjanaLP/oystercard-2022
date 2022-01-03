class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(station = nil)
    @entry_station = station
  end

  def end(station)
    @exit_station = station
    self
  end

  def complete?
    entry_station && exit_station
  end

  def fare
    complete? ? MIN_FARE : PENALTY_FARE
  end
end
