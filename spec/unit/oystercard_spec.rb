require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new }
  let(:max_balance)       { described_class::MAX_BALANCE }
  let(:min_fare)          { described_class::MIN_FARE }

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

  describe '#in_journey?' do
    before { oystercard.top_up(max_balance) }

    it 'is initially returns false' do
      expect(oystercard).not_to be_in_journey
    end

    context 'when touched in' do
      it 'returns true' do
        oystercard.touch_in
        expect(oystercard).to be_in_journey
      end
    end

    context 'when touched out' do
      it 'returns false' do
        oystercard.touch_in
        oystercard.touch_out
        expect(oystercard).not_to be_in_journey
      end
    end
  end

  describe '#touch_in' do
    context 'when balance is beow minimum fare' do
      it 'raises an error' do
        message = "Cannot touch in: balance below £#{min_fare}"
        expect { oystercard.touch_in }.to raise_error message
      end
    end
  end

  describe '#touch_out' do
    it 'deducts the fare from the balance' do
      oystercard.top_up(max_balance)
      oystercard.touch_in
      expect { oystercard.touch_out }.to change { oystercard.balance }.by(-min_fare)
    end
  end
end
