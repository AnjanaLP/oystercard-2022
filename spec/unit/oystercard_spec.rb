require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new }

  describe '#balance' do
    it 'is initially zero' do
      expect(subject.balance).to eq 0
    end
  end

  describe '#top_up' do
    it 'increases the balance by the given amount' do
      expect { oystercard.top_up(10) }.to change { oystercard.balance }.by(10)
    end
  end
end
