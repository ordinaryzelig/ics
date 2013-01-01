module RSpec::Core::DSL

  def it_unescapes(raw, unescaped)
    it "unescapes '#{raw}' into '#{unescaped}'" do
      line = "DESCRIPTION:#{raw}"
      event = ICS::Event.parse(line)

      event.description.should == unescaped
    end
  end

end
