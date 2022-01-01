require 'oystercard'

describe Oystercard do
  subject(:oystercard)    { described_class.new }
  
  describe '#balance' do
    it 'is initially zero' do
      expect(subject.balance).to eq 0
    end
  end
end
