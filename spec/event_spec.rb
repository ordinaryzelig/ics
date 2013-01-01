require 'spec_helper'

describe ICS::Event do

  it 'parses event data string and returns new Event' do
    event = ICS::Event.parse("SUMMARY:value with spaces\nSTATUS:val")

    event.summary.should == 'value with spaces'
    event.status.should  == 'val'
  end

  it 'parses multi-line attribute' do
    raw = <<-END
SUMMARY: one-liner
DESCRIPTION:this is on multi
 ple lines
URL: one-liner
    END
    event = ICS::Event.parse(raw)

    event.description.should == 'this is on multiple lines'
  end

  it 'should read a file, parse it, and return an array of events' do
    events = ICS::Event.file(File.open('spec/support/fixtures/example_events.ics'))
    events.size.should > 0
  end

  it 'should parse attributes ignoring extra data like time zone for DTSTART' do
    data = 'DTSTART;TZID=asdfasdf:20100331T200000'
    event = ICS::Event.parse(data)
    event.dtstart.should == '20100331T200000'
  end

end
