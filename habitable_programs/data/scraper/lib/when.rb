# Run me using the command "vado scrape.rb DAMS"

# Lists the terms in which a CS module runs, by scraping a module
# descriptor webpage (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# DAMS | y      | y      | n      |

require "nokogiri"
require "open-uri"

class When
  def run(module_name)
    # Parse the module descriptor webpage using a Ruby library called Nokogiri
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/undergraduate/modules/#{module_name.downcase}.html"))
    # Select the rows from the module info table (the table at the top of every module descriptor page)
    rows = doc.css("table#ModuleInfo tr")
    # Find the row with heading "Teaching"
    teaching_row = rows.find { |row| row.inner_text.include?("Teaching") }
    # Extract the text from the right-hand column in that row (e.g., Autumn 2-10, Spring 2-5)
    teaching_data = teaching_row.at_css("td").inner_text
    # Check which terms are included in that text
    autumn = teaching_data.include?("Autumn") ? "y" : "n"
    spring = teaching_data.include?("Spring") ? "y" : "n"
    summer = teaching_data.include?("Summer") ? "y" : "n"
    # Print out a summary of the findings
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"
    puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
  rescue StandardError => e
    puts "Failed to find teaching data for the module #{module_name}"
    raise e
  end
end

When.new.run(ARGV[0])
