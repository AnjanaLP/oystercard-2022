require 'journey'

describe Journey do
  subject(:journey)   { described_class.new(station) }
  let(:station)       { double :station, zone: 1 }
  let(:other_station) { double :station, zone: 1 }
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
      journey.end(other_station)
      expect(journey.exit_station).to eq other_station
    end

    it 'returns itself' do
      expect(journey.end(other_station)).to eq journey
    end
  end

  describe '#complete?' do
    context 'given both an entry and exit station' do
      it 'returns true' do
        journey.end(other_station)
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
      context 'when journey is within zone 1' do
        it 'returns the minimum fare' do
          journey.end(other_station)
          expect(journey.fare).to eq described_class::MIN_FARE
        end
      end

      context 'when journey is within zone 3' do
        it 'returns the minimum fare' do
          update_zones(3, 3)
          journey.end(other_station)
          expect(journey.fare).to eq described_class::MIN_FARE
        end
      end

      context 'when one zone boundary crossed' do
        it 'returns the minimum fare plus a charge for one boundary' do
          update_zones(6, 5)
          journey.end(other_station)
          expect(journey.fare).to eq 2
        end
      end

      context 'when two zone boundaries crossed' do
        it 'returns the minimum fare plus a charge for two boundaries' do
          update_zones(3, 5)
          journey.end(other_station)
          expect(journey.fare).to eq 3
        end
      end

      context 'when five zone boundaries crossed' do
        it 'returns the minimum fare plus a charge for five boundaries' do
          update_zones(7, 2)
          journey.end(other_station)
          expect(journey.fare).to eq 6
        end
      end
    end

    context 'when the journey is incomplete' do
      it 'returns the penalty fare' do
        expect(journey.fare).to eq described_class::PENALTY_FARE
      end
    end
  end

  def update_zones(entry_zone, exit_zone)
    allow(station).to receive(:zone).and_return(entry_zone)
    allow(other_station).to receive(:zone).and_return(exit_zone)
  end
end
