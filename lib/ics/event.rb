require 'date'

module ICS

  class Event

    # Given a hash of attributes, define a method for each key that returns the value.
    # Attributes stored in instance variable.
    def initialize(attributes = {})
      @attributes = attributes
      attributes.each do |key, val|
        unless respond_to?(key)
          self.class.send :define_method, key do
            @attributes[key]
          end
        end
      end
    end

    # Return time object.
    # Assumes time in UTC.
    def dtstart
      return nil unless @attributes[:dtstart]
      DateTime.parse(@attributes[:dtstart]).to_time.utc
    end
    alias_method :started_at, :dtstart

    def started_on
      dtstart.to_date if dtstart
    end

    class << self

      # Given an exported ical file, parse it and create events.
      def file(file)
        # format line endings.
        content = file.readlines.map(&:chomp).join($/)
        line_ending = $/
        content.split("BEGIN:VEVENT#{line_ending}")[1..-1].map do |data_string|
          data_string = data_string.split("END:VEVENT#{line_ending}").first
          new parse(data_string)
        end
      end

      def parse(str)
        str.split($/).inject({}) do |hash, line|
          key, value = line.split(':', 2)
          next hash if key =~ /^BEGIN/ # Ignore any other book ends.
          value = value.chomp if value
          key = key.split(';', 2).first # Ignore extra data other than just the name of the attribute.
          hash[key.downcase.to_sym] = value
          hash
        end
      end

    end

  end

end
