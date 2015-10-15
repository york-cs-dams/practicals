# Run me using the command "vado scrape.rb DAMS SEPR HACS"

# Lists the terms in which *several* CS module run, by scraping a module
# descriptor webpages (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# DAMS | y      | y      | n      |
# SEPR | y      | y      | y      |
# HACS | y      | n      | n      |

require "nokogiri"
require "open-uri"

class WhenMulti
  def run(*module_names)
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"
    module_names.each do |module_name|
      begin
        doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/undergraduate/modules/#{module_name.downcase}.html"))
        rows = doc.css("table#ModuleInfo tr")
        teaching_row = rows.find { |row| row.inner_text.include?("Teaching") }
        teaching_data = teaching_row.at_css("td").inner_text
        autumn = teaching_data.include?("Autumn") ? "y" : "n"
        spring = teaching_data.include?("Spring") ? "y" : "n"
        summer = teaching_data.include?("Summer") ? "y" : "n"
        puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
      rescue StandardError => e
        puts "Failed to find teaching data for the module #{module_name}"
        raise e
      end
    end
  end
end

WhenMulti.new.run(*ARGV)
