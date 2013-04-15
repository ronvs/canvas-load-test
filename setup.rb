require "yaml"
require "fileutils"
require_relative "lib/sis"
require_relative "lib/csv"
require_relative "lib/content"
require_relative "lib/global"

if ARGV.empty?
  puts "Usage: ruby setup.rb < all | update | sis_imports | discussions | content > [url]"
  exit
end

if ARGV.first.eql? "all"
  update
  sis_imports
  discussions
  content
elsif ARGV.first.eql? "sis_imports"
  sis_imports
elsif ARGV.first.eql? "discussions"
  discussions
elsif ARGV.first.eql? "content"
  content
elsif ARGV.first.eql? "update"
  update
end

if ARGV[1].nil?
  var = Global.from_yaml File.dirname(__FILE__) + "/config/global_variables.yml"
else
  var = Global.from_json ARGV[1]
  Global.to_yaml_from_json ARGV[1]
end

Global.check_dir File.dirname(__FILE__) + "/data"
require_relative "lib/canvas"
sis_import = SIS.new(var["num_of_courses"], var["num_of_users"], var["term_name"], var["term_id"])

puts "Setting load test data on #{Canvas::Server.server}"
puts "-------------------------------------------------------"

def sis_imports
  puts "Importing Term CSV"
  Canvas::Server.sis_import sis_import.terms

  puts "Importing Course CSV"
  Canvas::Server.sis_import sis_import.courses

  puts "Importing Users CSV"
  Canvas::Server.sis_import sis_import.users

  puts "Importing Enrollment CSV"
  Canvas::Server.sis_import sis_import.enrollments
end

def update
  # Setup server_config.csv for JMeter
  CSV.update_config_csv("server", "#{var["server_protocol"]},#{var["server_name"]},#{var["server_port"]},#{var["canvas_token"]}")
  CSV.update_config_csv("test", "#{var["num_of_courses"]},#{var["jmeter_users"]},#{var["jmeter_loops"]},#{var["jmeter_ramp_up"]},#{var["jmeter_delay_constant"]},#{var["jmeter_delay_deviation"]}")
  courses = Canvas::Course.load_test_courses var["num_of_courses"]
  CSV.update_config_csv("course","#{courses.first["id"]},#{courses.last["id"]}")
end

def discussions
  puts "Creating Discussion Topic"
  num = 1
  courses.each do |course|
    Canvas::Discussion.add course["id"], var["discussion_title"], var["discussion_message"]
    topic_id = Canvas::Discussion.topic_id course["id"], var["discussion_title"]
    CSV.update_data_csv("discussion", "#{course["id"]},#{topic_id}", num)
    num += 1
  end
end

def content
  puts "Getting random content from Wikipedia"
  CSV.generate_random_content(var["num_of_users"])
end

puts "Done"
puts ""
puts "-------------------------------------------------------"
puts "*** NOTE ***"
puts "- Ensure the #{sis_import.num_courses} Load Test Courses are PUBLISHED before running the JMeter test plan"

