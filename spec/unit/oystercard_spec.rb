require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new(journey_log) }
  let(:journey_log)       { double :journey_log, start: penalty_fare, refund_amount: penalty_fare, finish: penalty_fare }
  let(:journey)           { double :journey }
  let(:station)           { double :station }
  let(:max_balance)       { described_class::MAX_BALANCE }
  let(:min_balance)       { described_class::MIN_BALANCE }
  let(:penalty_fare)      { 6 }
  let(:min_fare)          { 1 }

  describe '#balance' do
    it 'initially returns zero' do
      expect(oystercard.balance).to eq 0
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
    context 'when balance is below the minimum' do
      it 'raises an error' do
        message = "Cannot touch in: balance below £#{min_balance} minimum"
        expect { oystercard.touch_in(station) }.to raise_error message
      end
    end

    context 'when balance is above the minimum' do
      before { oystercard.top_up(max_balance) }

      it 'calls the start method on the journey_log instance and passes it the entry station' do
        expect(journey_log).to receive(:start).with(station)
        oystercard.touch_in(station)
      end

      it 'deducts the penalty fare' do
        expect { oystercard.touch_in(station) }.to change { oystercard.balance }.by -penalty_fare
      end
    end
  end

  describe '#touch_out' do
    before do
      oystercard.top_up(max_balance)
    end

    it 'calls the finish method on the journey_log instance and passes it the exit station' do
      expect(journey_log).to receive(:finish).with(station)
      oystercard.touch_out(station)
    end

    context 'when journey is complete' do
      it 'refunds the penalty charged at touch in and deducts the minimum fare' do
        allow(journey_log).to receive(:finish).and_return min_fare
        oystercard.touch_in(station)
        refund_minus_fare = penalty_fare - min_fare
        expect { oystercard.touch_out(station) }.to change { oystercard.balance }.by(refund_minus_fare)
      end
    end

    context 'when journey is incomplete' do
      it 'refunds nothing and deducts the penalty fare' do
        allow(journey_log).to receive(:refund_amount).and_return(0)
        expect { oystercard.touch_out(station) }.to change { oystercard.balance }.by -penalty_fare
      end
    end
  end
end
