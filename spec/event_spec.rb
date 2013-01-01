require 'spec_helper'

describe ICS::Event do

  it 'parses event data string and returns new Event' do
    event = ICS::Event.parse("SUMMARY:value with spaces\nSTATUS:val")

    event.summary.should == 'value with spaces'
    event.status.should  == 'val'
  end

  it 'should read a file, parse it, and return an array of events' do
    events = ICS::Event.file(File.open('spec/support/fixtures/example_events.ics'))
    events.size.should == 2
  end

  it 'should parse attributes ignoring extra data like time zone for DTSTART' do
    data = 'DTSTART;TZID=asdfasdf:20100331T200000'
    event = ICS::Event.parse(data)
    event.dtstart.should == '20100331T200000'
  end

end
