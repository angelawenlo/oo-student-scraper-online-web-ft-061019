require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    html = Nokogiri::HTML(open(index_url))
    html.css("div.student-card").each do |student|
      student_details = {
       name: student.css("h4.student-name").text,
       location: student.css("p.student-location").text,
       profile_url: student.css("a").attribute("href").value}
      students << student_details
    end
    students
  end

  def self.scrape_profile_page(profile_url)
    student_profile = {}

    html = Nokogiri::HTML(open(profile_url))
    html.css("div.social-icon-container a").each do |student|
        if student.attribute("href").value.include?("twitter")
          student_profile[:twitter] = student.attribute("href").value
        elsif student.attribute("href").value.include?("linkedin")
          student_profile[:linkedin] = student.attribute("href").value
        elsif student.attribute("href").value.include?("github")
          student_profile[:github] = student.attribute("href").value
        else
          student_profile[:blog] = student.attribute("href").value
        end
    end

      student_profile[:profile_quote] = html.css("div.main-wrapper.profile .vitals-text-container .profile-quote").text
      student_profile[:bio] = html.css("div.main-wrapper.profile .description-holder p").text

      student_profile
    end
  end
