require 'spec_helper'

describe ICS::Event do

  it 'parses event data string and generates a hash' do
    ICS::Event.parse("NAME:value with spaces\nKEY:val").should == {:name => 'value with spaces', :key => 'val'}
  end

  it 'should read a file, parse it, and return an array of events' do
    file = file_with_content(<<-END)
BEGIN:VEVENT
INDEX:0
END:VEVENT
BEGIN:VEVENT
INDEX:1
END:VEVENT
END
    events = ICS::Event.file(file)
    events.size.should == 2
    events.each_with_index do |event, i|
      event.index.should == i.to_s
    end
  end

  it 'should be initialized with a hash of attributes and have keys defined as methods returning values' do
    event = ICS::Event.new(:attribute => '1')
    event.should respond_to(:attribute)
    event.attribute.should == '1'
  end

  it '#dtstart should return time object' do
    time = Time.now.utc
    event = ICS::Event.new(:dtstart => time.strftime('%Y%m%dT%H%M%SZ'))
    event.dtstart.to_i.should == time.to_i
  end

  it 'should handle real file' do
    events = ICS::Event.file(File.open('spec/example_events.ics'))
    events.size.should == 2
  end

  it 'should parse attributes ignoring extra data like time zone for DTSTART' do
    data = 'DTSTART;TZID=asdfasdf:1'
    ICS::Event.parse(data).should == {:dtstart => '1'}
  end

end
