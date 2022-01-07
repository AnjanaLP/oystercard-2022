require 'journey_log'

describe JourneyLog do
  subject(:journey_log)   { described_class.new(journey_class) }
  let(:journey_class)     { double :journey_class, new: journey }
  let(:journey)           { double :journey, default_charge: 6, fare: 6 }
  let(:station)           { double :station }

  describe '#journeys' do
    it 'is initially empty' do
      expect(journey_log.journeys).to be_empty
    end
  end

  describe '#start' do
    it 'calls the new method on the Journey class' do
      expect(journey_class).to receive(:new).with(station)
      journey_log.start(station)
    end

    it 'adds the current journey to the journeys collection' do
      journey_log.start(station)
      expect(journey_log.journeys).to include journey
    end

    it 'returns the entry fare' do
      expect(journey_log.start(station)).to eq journey.default_charge
    end
  end

  describe '#end' do
    before { allow(journey).to receive(:end).and_return journey }

    context 'when the current journey has no entry station' do
      it 'creates a new journey instance' do
        expect(journey_class).to receive(:new)
        journey_log.finish(station)
      end

      it 'adds the current journey to the journeys collection' do
        journey_log.finish(station)
        expect(journey_log.journeys).to include journey
      end
    end

    context 'when the current journey has an entry station' do
      before { journey_log.start(station) }

      it 'does not create a new journey instance' do
        expect(journey_class).not_to receive(:new)
        journey_log.finish(station)
      end

      it 'does not add the current journey to the journeys collection' do
        number_of_journeys = journey_log.journeys.count
        expect { journey_log.finish(station) }.not_to change {number_of_journeys }
      end
    end

    it 'calls the end method on the journey instance' do
      expect(journey).to receive(:end).with(station)
      journey_log.finish(station)
    end

    it 'sets the current_journey to nil' do
      journey_log.finish(station)
      expect(journey_log.current_journey).to be_nil
    end

    it 'returns the fare' do
      expect(journey_log.finish(station)).to eq journey.fare
    end
  end

  describe '#outstanding_charges' do
    it 'calls the default_charges method on the last journey in the journeys collection' do
      last_journey = journey_log.journeys.last
      expect(last_journey).to receive(:default_charge)
      journey_log.outstanding_charges
    end
  end
end
