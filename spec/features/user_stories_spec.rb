describe 'User Stories' do
  let(:oystercard)    { Oystercard.new }
  let(:max_balance)   { Oystercard::MAX_BALANCE }
  let(:min_fare)      { Oystercard::MIN_FARE}

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
    oystercard.top_up(max_balance)
    expect(oystercard.balance).to eq(max_balance)
  end

  # In order to protect my money from theft or loss
  # As a customer
  # I want a maximum limit (of £90) on my card
  it 'an oystercard has a maximum balance limit' do
    oystercard.top_up(max_balance)
    message = "Cannot top up: £#{max_balance} limit exceeded"
    expect{ oystercard.top_up(1) }.to raise_error message
  end

  # In order to get through the barriers
  # As a customer
  # I need to touch in and out
  it 'an oystercard is initially not in a journey' do
    oystercard.top_up(max_balance)
    expect(oystercard).not_to be_in_journey
  end

  it 'a touched in oystercard is in a journey' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    expect(oystercard).to be_in_journey
  end

  it 'a touched out oystercard is not in a journey' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    oystercard.touch_out(:euston)
    expect(oystercard).not_to be_in_journey
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount (£1) for a single journey
  it 'an oystercard must have a balance of the minimum fare to touch in' do
    message = "Cannot touch in: balance below £#{min_fare}"
    expect { oystercard.touch_in(:angel) }.to raise_error message
  end

  # In order to pay for my journey
  # As a customer
  # When my journey is complete, I need the correct amount deducted from my card
  it 'the fare is deducted from an oystercard on touch out' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    expect { oystercard.touch_out(:euston) }.to change { oystercard.balance }.by(-min_fare)
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'an oystercard stores the entry station on touch in' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    expect(oystercard.entry_station).to eq :angel
  end

  it 'an oystercard forgets the entry station on touch out' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    oystercard.touch_out(:euston)
    expect(oystercard.entry_station).to be_nil
  end

  # In order to know where I have been
  # As a customer
  # I want to see all my previous trips
  it 'an oystercard stores all journeys' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    oystercard.touch_out(:euston)
    oystercard.touch_in(:baker_street)
    oystercard.touch_out(:marylebone)
    expect(oystercard.journeys).to eq [ { entry_station: :angel, exit_station: :euston },
                                        { entry_station: :baker_street, exit_station: :marylebone } ]
  end
end
