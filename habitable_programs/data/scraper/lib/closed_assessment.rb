# Lists the terms in which a CS module is assessed), by scraping a module
# descriptor webpage (e.g. https://www.cs.york.ac.uk/modules/dams.html)
# producing a table, for example:
#
#      | Autumn | Spring | Summer |
# ---------------------------------
# NUMA | n      | y      | y      |
#
# This scraper doesn't consider open assessments, and doesn't work for modules
# with more than one closed assessment. This is deliberate!

require "nokogiri"
require "open-uri"

class ClosedAssessment
  def run(module_name)
    # Parse the module descriptor webpage using a Ruby library called Nokogiri
    doc = Nokogiri::HTML(open("https://www.cs.york.ac.uk/undergraduate/modules/#{module_name.downcase}.html"))
    # Select the rows from the module info table (the table at the top of every module descriptor page)
    rows = doc.css("table#ModuleInfo tr")
    # Find the row with heading "Teaching"
    assessment_row = rows.find { |row| row.inner_text.include?("Assessment") }
    # Extract the text from the right-hand column in that row (e.g., [100%] Closed Exam Summer 5-7, 2.00 hours)
    assessment_data = assessment_row.at_css("td").inner_text
    analyse(module_name, assessment_data)
  end

  def analyse(module_name, assessment_data)
    # Check which terms are included in that text
    autumn = assessment_data.include?("Autumn") ? "y" : "n"
    spring = assessment_data.include?("Spring") ? "y" : "n"
    summer = assessment_data.include?("Summer") ? "y" : "n"
    # Print out a summary of the findings
    puts "     | Autumn | Spring | Summer |"
    puts "---------------------------------"
    puts "#{module_name} | #{autumn}      | #{spring}      | #{summer}      |"
  end
end

ClosedAssessment.new.run("NUMA")
