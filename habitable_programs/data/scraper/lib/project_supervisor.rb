# Update...

require "nokogiri"
require "open-uri"

class ProjectSupervisors
  def run
    academics.each do |academic|
      puts "#{academic.name.ljust(30)} Score: #{academic.wisdom + academic.availability}.    Bribe: #{academic.bribe}"
    end
  end

  private

  def academics
    academics = []
    rows.each do |r|
      if r.inner_text.include?('CSE')
        unless r.inner_text.include?('Teaching Staff')
          name = r.css("td.white a").inner_text
          position = :lecturer
          position = :senior if r.inner_text.include? "Senior"
          position = :professor if r.inner_text.include? "Prof"
          academics << Academic.new(name: name, position: position)
        end
      end
    end
    academics
  end

  def rows
    # Parse the people webpage using a Ruby library called Nokogiri
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/people/"))
    # Select only the rows that describe a person
    doc.css("td.white").map(&:parent)
  end
end

class Academic
  attr_reader :name, :position

  def initialize(name:, position:)
    @name = name
    @position = position
  end

  def wisdom
    if @position == :lecturer
      sample(1, 5)
    elsif @position == :senior
      sample(10, 15)
    else
      sample(20, 30)
    end
  end

  def availability
    if @position == :lecturer
      sample(20, 25)
    elsif @position == :senior
      sample(15, 20)
    else
      sample(1, 10)
    end
  end

  def bribe
    if @position == :lecturer
      %i(chocolate coffee).sample
    elsif @position == :senior
      %i(theatre_tickets cake).sample
    else
      %i(truffles champagne).sample
    end
  end

  private

  def sample(min, max)
    (min..max).to_a.sample
  end
end

ProjectSupervisors.new.run
