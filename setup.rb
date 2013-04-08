#!/Users/santos/.rvm/rubies/ruby-1.9.3-p286/bin/ruby

require "yaml"
require "fileutils"
require_relative "lib/canvas"
require_relative "lib/sis"
require_relative "lib/csv"
require_relative "lib/content"

@run_sis_imports = false
@run_discussions = false
@run_content = false

if ARGV.empty?
  puts "Usage: ruby setup.rb < all | sis_imports | discussions | content >"
  exit
end

if ARGV.first.eql? "all"
  @run_sis_imports = true
  @run_assignments = true
  @run_discussions = true
  @run_content = true
elsif ARGV.first.eql? "sis_imports"
  @run_sis_imports = true
elsif ARGV.first.eql? "discussions"
  @run_discussions = true
elsif ARGV.first.eql? "content"
  @run_content = true
end

var = YAML.load_file File.dirname(__FILE__) + "/config/global_variables.yml"
sis_import = SIS.new(var["num_of_courses"], var["num_of_users"], var["term_name"], var["term_id"])

puts "Setting load test data on #{Canvas::Server.server}"
puts "-------------------------------------------------------"

if @run_sis_imports
  puts "Importing Term CSV"
  Canvas::Server.sis_import sis_import.terms

  puts "Importing Course CSV"
  Canvas::Server.sis_import sis_import.courses

  puts "Importing Users CSV"
  Canvas::Server.sis_import sis_import.users

  puts "Importing Enrollment CSV"
  Canvas::Server.sis_import sis_import.enrollments
end

# Setup server_config.csv for JMeter
CSV.update_config_csv("server", "#{var["server_protocol"]},#{var["server_name"]},#{var["server_port"]},#{var["canvas_token"]}")
CSV.update_config_csv("test", "#{var["num_of_courses"]},#{var["jmeter_users"]},#{var["jmeter_loops"]},#{var["jmeter_ramp_up"]},#{var["jmeter_delay_constant"]},#{var["jmeter_delay_deviation"]}")
courses = Canvas::Course.load_test_courses var["num_of_courses"]
CSV.update_config_csv("course","#{courses.first["id"]},#{courses.last["id"]}")


if @run_discussions
  puts "Creating Discussion Topic"
  num = 1
  courses.each do |course|
    Canvas::Discussion.add course["id"], var["discussion_title"], var["discussion_message"]
    topic_id = Canvas::Discussion.topic_id course["id"], var["discussion_title"]
    CSV.update_data_csv("discussion", "#{course["id"]},#{topic_id}", num)
    num += 1
  end
end

if @run_content
  puts "Getting random content from Wikipedia"
  CSV.generate_random_content(var["num_of_users"])
end

puts "Done"
puts ""
puts "-------------------------------------------------------"
puts "*** NOTE ***"
puts " - Publish the #{sis_import.num_courses} Load Test Courses before running the JMeter test plan"

