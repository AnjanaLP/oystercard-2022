describe 'User Stories' do
  let(:oystercard)    { Oystercard.new }
  let(:entry_station) { Station.new( name: :angel, zone: 2) }
  let(:exit_station)  { Station.new( name: :euston, zone: 2) }
  let(:max_balance)   { Oystercard::MAX_BALANCE }
  let(:min_balance)   { Oystercard::MIN_BALANCE }
  let(:penalty_fare)  { Journey::PENALTY_FARE}
  let(:min_fare)      { Journey::MIN_FARE }

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
    expect { oystercard.top_up(max_balance) }.to change { oystercard.balance }.by(max_balance)
  end

  # In order to protect my money
  # As a customer
  # I don't want to put too much money on my card
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
    expect{ oystercard.touch_in(entry_station) }.not_to raise_error
  end

  it 'an oystercard can be touched out' do
    oystercard.top_up(max_balance)
    expect{ oystercard.touch_out(exit_station) }.not_to raise_error
  end

  # In order to pay for my journey
  # As a customer
  # I need to have the minimum amount for a single journey
  it 'an oystercard must have a minimum balance to touch in' do
    message = "Cannot touch in: balance below £#{min_balance} minimum"
    expect { oystercard.touch_in(entry_station) }.to raise_error message
  end

  # In order to pay for my journey
  # As a customer
  # I need to know where I've travelled from
  it 'an oystercard stores the entry station on touch in' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(entry_station)
    journeys = oystercard.journey_log.journeys
    expect(journeys.last.entry_station).to eq entry_station
  end

  # In order to know where I have been
  # As a customer
  # I want to see all my previous trips
  it 'an oystercard stores all journeys (complete or not)' do
    oystercard.top_up(max_balance)
    oystercard.touch_in(entry_station)
    oystercard.touch_out(exit_station)
    oystercard.touch_out(exit_station)
    oystercard.touch_in(entry_station)
    journeys = oystercard.journey_log.journeys
    first_journey = journeys[0]
    second_journey = journeys[1]
    third_journey = journeys[2]
    expect(journeys.count).to eq 3
    expect(first_journey.entry_station).to eq entry_station
    expect(first_journey.exit_station).to eq exit_station
    expect(second_journey.entry_station).to be_nil
    expect(second_journey.exit_station).to eq exit_station
    expect(third_journey.entry_station).to eq entry_station
    expect(third_journey.exit_station).to be_nil
  end

  # In order to know how far I have travelled
  # As a customer
  # I want to know what zone a station is in
  it 'a station knows what zone it is in' do
    expect(entry_station.zone).to eq 2
  end

  # In order to be charged correctly
  # As a customer
  # I need a penalty charge deducted if I fail to touch in or out
  context 'when the journey has not been touched out' do
    it 'a penalty fare is charged' do
      oystercard.top_up(max_balance)
      oystercard.touch_in(entry_station)
      expect { oystercard.touch_in(entry_station) }.to change { oystercard.balance }.by(-penalty_fare)
    end
  end

  context 'when the journey has not been touched in' do
    it 'a penalty fare is charged' do
      oystercard.top_up(max_balance)
      expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(-penalty_fare)
    end
  end

  # In order to pay for my journey
  # As a customer
  # I need to pay for my journey when it's complete
  context 'when the journey is complete' do
    context 'when no zone boundaries crossed' do
      it 'the penalty from touch in is refunded and minimum fare is charged' do
        oystercard.top_up(max_balance)
        oystercard.touch_in(entry_station)
        refund_and_fare = penalty_fare - min_fare
        expect { oystercard.touch_out(exit_station) }.to change { oystercard.balance }.by(refund_and_fare)
      end
    end

    # In order to be charged the correct amount
    # As a customer
    # I need to have the correct fare calculated
    context 'when zone boundaries are crossed' do
      it 'the penalty from touch in is refunded and a fare dependent on zones crossed is charged' do
        zone_4_station = Station.new(name: :heathrow, zone: 4)
        oystercard.top_up(max_balance)
        oystercard.touch_in(entry_station)
        refund_and_fare = penalty_fare - 3
        expect { oystercard.touch_out(zone_4_station) }.to change { oystercard.balance }.by(refund_and_fare)
      end
    end
  end
end
