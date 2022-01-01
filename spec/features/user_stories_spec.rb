describe 'User Stories' do

  # In order to use public transport
  # As a customer
  # I want money on my card
  it 'an oystercard initially has zero balance' do
    oystercard = Oystercard.new
    expect(oystercard.balance).to eq 0
  end
end
