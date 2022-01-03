require 'journey'

describe Journey do
  subject(:journey)   { described_class.new(station) }
  let(:station)       { double :station }

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

  describe '#complete?' do
    context 'given both an entry and exit station' do
      it 'returns true' do
        journey.end(station)
        expect(journey).to be_complete
      end
    end

    context 'given an entry but no exit station' do
      it 'returns false' do
        expect(journey).not_to be_complete
      end
    end

    context 'given an exit but no entry station' do
      subject(:journey)   { described_class.new }
      it 'returns false' do
        journey.end(station)
        expect(journey).not_to be_complete
      end
    end

    context 'given neither an entry nor an exit station' do
      subject(:journey)   { described_class.new }
      it 'returns false' do
        expect(journey).not_to be_complete
      end
    end
  end

  describe '#fare' do
    context 'when the journey is complete' do
      it 'returns the minimum fare' do
        journey.end(station)
        expect(journey.fare).to eq described_class::MIN_FARE
      end
    end

    context 'when the journey is incomplete' do
      it 'returns the penalty fare' do
        expect(journey.fare).to eq described_class::PENALTY_FARE
      end
    end
  end
end
