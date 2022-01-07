require 'journey'

describe Journey do
  subject(:journey)   { described_class.new(station) }
  let(:station)       { double :station }
  let(:min_fare)      { described_class::MIN_FARE }
  let(:penalty_fare)  { described_class::PENALTY_FARE }

  describe '#entry_station' do
    context 'when given a station on initialize' do
      it 'returns the given entry station' do
        expect(journey.entry_station).to eq station
      end
    end

    context 'when given no station on initialize' do
      subject(:journey)   { described_class.new }
      it 'returns nil' do
        expect(journey.entry_station).to eq nil
      end
    end
  end

  describe '#end' do
    it 'stores the given exit station' do
      journey.end(station)
      expect(journey.exit_station).to eq station
    end

    it 'returns itself' do
      expect(journey.end(station)).to eq journey
    end
  end

  describe '#fare' do
    context 'given both an entry and exit station' do
      it 'returns the minimum fare' do
        journey.end(station)
        expect(journey.fare).to eq min_fare
      end
    end

    context 'given an entry but no exit station' do
      it 'returns the penalty fare' do
        expect(journey.fare).to eq penalty_fare
      end
    end

    context 'given an exit but no entry station' do
      subject(:journey)   { described_class.new }
      it 'returns the penalty fare' do
        journey.end(station)
        expect(journey.fare).to eq penalty_fare
      end
    end

    context 'given neither an entry nor an exit station' do
      subject(:journey)   { described_class.new }
      it 'returns the penalty_fare' do
        expect(journey.fare).to eq penalty_fare
      end
    end
  end
end
