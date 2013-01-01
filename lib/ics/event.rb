require 'date'

module ICS

  class Event

    attr_accessor :action
    attr_accessor :alarmuid
    attr_accessor :attach
    attr_accessor :attendee
    attr_accessor :categories
    attr_accessor :created
    attr_accessor :description
    attr_accessor :dtend
    attr_accessor :dtstamp
    attr_accessor :dtstart
    attr_accessor :last_modified
    attr_accessor :location
    attr_accessor :sequence
    attr_accessor :status
    attr_accessor :summary
    attr_accessor :transp
    attr_accessor :trigger
    attr_accessor :uid
    attr_accessor :url
    attr_accessor :x_apple_default_alarm
    attr_accessor :x_wr_alarmuid

    def initialize(attributes = {})
      attributes.each do |key, val|
        send("#{key}=", val)
      end
    end

    class << self

      # Given an exported ical file, parse it and create events.
      def file(file)
        # format line endings.
        content = file.readlines.map(&:chomp).join($/)
        line_ending = $/
        content.split("BEGIN:VEVENT#{line_ending}")[1..-1].map do |data_string|
          data_string = data_string.split("END:VEVENT#{line_ending}").first
          parse(data_string)
        end
      end

      # Parse data and return new Event.
      def parse(str)
        chunks = chunk(str.split($/))
        attributes = chunks.inject({}) do |hash, line|
          key, value = line.split(':', 2)
          next hash if key =~ /^BEGIN$|^END$/ # Ignore any other book ends.
          value = value.chomp if value
          key =
            key.
            split(';', 2).
            first. # Ignore extra data other than just the name of the attribute.
            gsub('-', '_') # underscore.
          hash[key.downcase.to_sym] = value
          hash
        end

        new(attributes)
      end

    private

      # Consolidate multi-line values.
      def chunk(lines)
        lines.each_with_object([]) do |line, chunks|
          if line.start_with? ' '
            chunks.last << line[1..line.length]
          else
            chunks << line
          end
        end
      end

    end

  end

end
