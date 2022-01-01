require 'station'

describe Station do
  subject(:station)   { described_class.new(name: :angel, zone: 1) }

  describe '#name' do
    it 'returns the name of the station' do
      expect(station.name).to eq :angel
    end
  end

  describe '#zone' do
    it 'returns the zone the station is in' do
      expect(station.zone).to eq 1
    end
  end
end
