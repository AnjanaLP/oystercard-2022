# Oystercard

This program emulates the Oystercard system for the London Underground. The requirements have been broken down into the user stories below which have been implemented using the BDD cycle with a test driven approach.

Unit tests include test doubles to effectively isolate the single class being tested and feature tests check correct integration behaviour between the classes - test coverage is 100%.

The Single Responsibility Principle has been adhered to in all classes and methods. The Oystercard class is responsible for maintaining the balance balance through touch in and touch out. The JourneyLog class is responsible for recording the journey history. The Journey class is responsible for information relating to a single journey. The Station class holds information about a station's name and zone.
Oystercard only sends messages to the JourneyLog, Station is never aware of OysterCard's existence and OysterCard never communicates directly with Journey. Dependencies have been injected with defaults provided where appropriate.

An oystercard needs to have a minimum balance equivalent to the penalty fare of £6 in order to touch in. The balance cannot be topped up above the maximum balance limit of £90. On touch in, an oystercard incurs the penalty charge by default which is then refunded if the journey is successfully completed on touch out. Likewise, an oystercard incurs the penalty charge on touch out if there was no touch in.   Otherwise the fare will be deducted and is calculated depending on the number of zones crossed: £1 for every journey, plus £1 for every zone boundary crossed. So, a journey within the same zone will cost £1, the journey between zones 1 and 2 will cost £2, and the journey between zones 3 and 5 will cost £3 etc.

JourneyLog's journeys method returns a list of all previous journeys and has been implemented without exposing the internal array to external modification. An attribute reader would have returned the actual object which could then call any of its methods and potentially change its state in a way that is not consistent with the rules of the domain. This has been prevented by returning a copy of the object instead.

## User Stories
```
In order to use public transport
As a customer
I want money on my card

In order to keep using public transport
As a customer
I want to add money to my card

In order to protect my money
As a customer
I don't want to put too much money on my card

In order to pay for my journey
As a customer
I need my fare deducted from my card

In order to get through the barriers
As a customer
I need to touch in and out

In order to pay for my journey
As a customer
I need to have the minimum amount for a single journey

In order to pay for my journey
As a customer
I need to pay for my journey when it's complete

In order to pay for my journey
As a customer
I need to know where I've travelled from

In order to know where I have been
As a customer
I want to see to all my previous trips

In order to know how far I have travelled
As a customer
I want to know what zone a station is in

In order to be charged correctly
As a customer
I need a penalty charge deducted if I fail to touch in or out

In order to be charged the correct amount
As a customer
I need to have the correct fare calculated
```

## How to setup

Clone the repo to your local machine, change into the directory and install the needed gems:
```
$ bundle install
```

To run the test suite:
```
$ rspec
```

## Technologies used
- Ruby
- RSpec
- SimpleCov

## Code example
```ruby
3.1.0 :001 > require './lib/Oystercard'
 => true
3.1.0 :002 > oystercard = Oystercard.new
 => #<Oystercard:0x0000000104901c58...
3.1.0 :003 > oystercard.top_up(5)
 => 5
3.1.0 :004 > station = Station.new(name: :angel, zone: 1)
 => #<Station:0x00000001041933e0 @name=:angel, @zone=1>
3.1.0 :005 > station.zone
 => 1
3.1.0 :006 > oystercard.touch_in(station)
Cannot touch in: balance below £6 minimum (RuntimeError)
3.1.0 :007 > oystercard.top_up(86)
Cannot top up: £90 limit exceeded (RuntimeError)
3.1.0 :008 > oystercard.top_up(50)
 => 55
3.1.0 :009 > oystercard.touch_in(Station.new(name: :euston, zone: 1))
 => 49
3.1.0 :010 > oystercard.touch_out(Station.new(name: :ealing, zone: 3))
 => 52
3.1.0 :011 > oystercard.touch_out(Station.new(name: :aldgate, zone: 1))
 => 46
3.1.0 :012 > oystercard.touch_in(Station.new(name: :farringdon, zone: 1))
 => 40
3.1.0 :013 > oystercard.touch_in(Station.new(name: :hounslow, zone: 5))
 => 34
3.1.0 :014 > oystercard.touch_out(Station.new(name: :heathrow, zone: 5))
 => 39
3.1.0 :015 > journey_log = oystercard.journey_log
 => #<JourneyLog:0x0000000104901b90...                                                                   
3.1.0 :016 > journey_log.journeys
 =>
 [#<Journey:0x00000001048d0590                                                                        
 @entry_station=<Station:0x00000001048d0978 @name=:euston, @zone=1>,                               
 @exit_station=<Station:0x0000000104bb8c30 @name=:ealing, @zone=3>>,                               
 #<Journey:0x0000000104bc1dd0                                                                        
 @entry_station=nil,                                                 
 @exit_station=<Station:0x0000000104bc1e48 @name=:aldgate, @zone=1>>,
 #<Journey:0x0000000104ab27a0                                       
 @entry_station=<Station:0x0000000104ab27c8 @name=:farringdon, @zone=1>,
 @exit_station=nil>,                                               
 #<Journey:0x0000000104bd8120                                       
 @entry_station=<Station:0x0000000104bd8148 @name=:hounslow, @zone=5>,
 @exit_station=<Station:0x0000000104bcbab0 @name=:heathrow, @zone=5>>]
 ```                                                                     
