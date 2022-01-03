require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new(journey_class) }
  let(:journey_class)     { double :journey_class, new: journey }
  let(:journey)           { double :journey, fare: 1, complete?: nil, end: nil }
  let(:station)           { double :station }
  let(:max_balance)       { Oystercard::MAX_BALANCE }
  let(:min_fare)          { Journey::MIN_FARE }
  let(:penalty_fare)      { Journey::PENALTY_FARE }

  describe '#balance' do
    it 'is initially zero' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'increases the balance by the given amount' do
      expect { oystercard.top_up(max_balance) }.to change { oystercard.balance }.by(max_balance)
    end

    context 'when maximum balance limit exceeded' do
      it 'raises an error' do
        oystercard.top_up(max_balance)
        message = "Cannot top up: £#{max_balance} limit exceeded"
        expect{ oystercard.top_up(1) }.to raise_error message
      end
    end
  end

  describe '#touch_in' do
    context 'when balance is below minimum fare' do
      it 'raises an error' do
        message = "Cannot touch in: balance below £#{min_fare}"
        expect { oystercard.touch_in(station) }.to raise_error message
      end
    end

    context 'when sufficient balance' do
      before do
        oystercard.top_up(max_balance)
      end

      it 'creates a new journey instance' do
        expect(journey_class).to receive(:new).with(station)
        oystercard.touch_in(station)
      end

      it 'adds the current journey to the journeys collection' do
        oystercard.touch_in(station)
        expect(oystercard.journeys).not_to be_empty
      end

      it 'deducts the penalty fare by default' do
        expect { oystercard.touch_in(station) }.to change { oystercard.balance }.by(-penalty_fare)
      end
    end
  end

  describe '#touch_out' do
    before do
      oystercard.top_up(max_balance)
    end

    context 'when not touched in during the current journey' do
      it 'deducts the penalty fare' do
        allow(journey).to receive(:fare).and_return 6
        expect{ oystercard.touch_out(station) }.to change { oystercard.balance }.by(-penalty_fare)

      end

      it 'adds the current journey to the journeys collection' do
        oystercard.touch_out(station)
        number_of_journeys = oystercard.journeys.count
        expect(number_of_journeys).to eq 1
      end
    end

    context 'when touched in during the current journey' do
      before do
        oystercard.touch_in(station)
        oystercard.touch_out(station)
      end

      it 'reimburses the penalty fare and deducts the minimum fare' do
        allow(journey).to receive(:fare).and_return 1
        expect(oystercard.balance).to eq 89
      end

      it 'does not create a new journey instance' do
        number_of_journeys = oystercard.journeys.count
        expect(number_of_journeys).to eq 1
      end
    end

    it 'calls the end method on the journey instance' do
      expect(journey).to receive(:end).with(station)
      oystercard.touch_out(station)
    end

    it 'sets the current_journey to nil' do
      oystercard.touch_out(station)
      expect(oystercard.current_journey).to be_nil
    end
  end

  describe '#journeys' do
    it 'is initially empty' do
      expect(oystercard.journeys).to be_empty
    end
  end
end
