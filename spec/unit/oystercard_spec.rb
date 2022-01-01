require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new }
  let(:max_balance)       { described_class::MAX_BALANCE }

  describe '#balance' do
    it 'is initially zero' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'increases the balance by the given amount' do
      expect { oystercard.top_up(10) }.to change { oystercard.balance }.by(10)
    end

    context 'when maximum balance limit exceeded' do
      it 'raises an error' do
        oystercard.top_up(max_balance)
        message = "Cannot top up: £#{max_balance} limit exceeded"
        expect{ oystercard.top_up(1) }.to raise_error message
      end
    end
  end
end
