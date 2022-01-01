describe 'User Stories' do
  let(:oystercard)    { Oystercard.new }
  let(:max_balance)   { Oystercard::MAX_BALANCE }

  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'an oystercard initially has zero balance' do
    expect(oystercard.balance).to eq 0
  end

  # In order to keep using public transport
  # As a customer
  # I want to add money to my card
  it 'an oystercard can be topped up to increase the balance' do
    oystercard.top_up(10)
    expect(oystercard.balance).to eq(10)
  end

  # In order to protect my money from theft or loss
  # As a customer
  # I want a maximum limit (of £90) on my card
  it 'an oystercard has a maximum balance limit' do
    oystercard.top_up(max_balance)
    message = "Cannot top up: £#{max_balance} limit exceeded"
    expect{ oystercard.top_up(1) }.to raise_error message
  end
end
