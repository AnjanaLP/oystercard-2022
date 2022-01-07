class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station

  def initialize(station = nil)
    @entry_station = station
    @exit_station = nil
  end

  def end(station)
    @exit_station = station
    self
  end

  def fare
    complete? ? calculated_fare : PENALTY_FARE
  end

  def complete?
    entry_station && exit_station
  end

  private

  def calculated_fare
    (entry_station.zone - exit_station.zone).abs + MIN_FARE
  end
end
