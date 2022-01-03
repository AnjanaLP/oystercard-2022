describe 'User Stories' do
  let(:oystercard)    { Oystercard.new }
  let(:angel)         { Station.new( name: :angel, zone: 1) }
  let(:max_balance)   { Oystercard::MAX_BALANCE }
  let(:min_fare)      { Journey::MIN_FARE }
  let(:penalty_fare)  { Journey::PENALTY_FARE }

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
  it 'an oystercard can be touched in' do
    oystercard.top_up(max_balance)
    expect{ oystercard.touch_in(:angel) }.not_to raise_error
  end

  it 'an oystercard can be touched out' do
    oystercard.top_up(max_balance)
    expect{ oystercard.touch_out(:angel) }.not_to raise_error
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
  context 'when the journey is complete' do
    it 'the minimum fare is deducted on touch out' do
      oystercard.top_up(10)
      oystercard.touch_in(:angel)
      oystercard.touch_out(:euston)
      expect(oystercard.balance).to eq 9
    end
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'an oystercard stores the entry station on touch in' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    last_journey = oystercard.journeys.last
    expect(last_journey.entry_station).to eq :angel
  end

  # In order to know where I have been
  # As a customer
  # I want to see all my previous trips
  it 'an oystercard stores all journeys' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(:angel)
    oystercard.touch_out(:euston)
    oystercard.touch_in(:baker_street)
    oystercard.touch_in(:marylebone)
    oystercard.touch_out(:heathrow)
    oystercard.touch_out(:farringdon)
    expect(oystercard.journeys[0].entry_station).to eq :angel
    expect(oystercard.journeys[0].exit_station).to eq :euston
    expect(oystercard.journeys[1].entry_station).to eq :baker_street
    expect(oystercard.journeys[1].exit_station).to eq nil
    expect(oystercard.journeys[2].entry_station).to eq :marylebone
    expect(oystercard.journeys[2].exit_station).to eq :heathrow
    expect(oystercard.journeys[3].entry_station).to eq nil
    expect(oystercard.journeys[3].exit_station).to eq :farringdon
  end

  # In order to know how far I have travelled
  # As a customer
  # I want to know what zone a station is in
  it 'a station knows what zone it is in' do
    station = Station.new(name: :angel, zone: 1)
    expect(station.zone).to eq 1
  end

  # In order to be charged correctly
  # As a customer
  # I need a penalty charge deducted if I fail to touch in or out
  context 'when the oystercard is not touched out' do
    it 'the penalty fare is deducted' do
      oystercard.top_up(max_balance)
      expect { oystercard.touch_in(:angel) }.to change { oystercard.balance }.by -6
    end
  end

  context 'when the oystercard is not touched in' do
    it 'the penalty fare is deducted' do
      oystercard.top_up(max_balance)
      expect { oystercard.touch_out(:angel) }.to change { oystercard.balance }.by -6
    end
  end
end
