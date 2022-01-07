class Journey
  MIN_FARE = 1
  PENALTY_FARE = 6

  attr_reader :entry_station, :exit_station, :default_charge

  def initialize(station = nil)
    @entry_station = station
    @default_charge = PENALTY_FARE
  end

  def end(station)
    @exit_station = station
    self
  end

  def fare
    if complete?
      MIN_FARE
    else
      reset_default_charge
      PENALTY_FARE
    end
  end

  private

  def reset_default_charge
    @default_charge = 0
  end

  def complete?
    entry_station && exit_station
  end
end
