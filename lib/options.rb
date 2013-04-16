require_relative "csv"
require_relative "canvas"

module Options
  extend self

  def sis_imports(sis_data)
    puts "Importing Term CSV"
    Canvas::Server.sis_import sis_data.terms

    puts "Importing Course CSV"
    Canvas::Server.sis_import sis_data.courses

    puts "Importing Users CSV"
    Canvas::Server.sis_import sis_data.users

    puts "Importing Enrollment CSV"
    Canvas::Server.sis_import sis_data.enrollments

    puts "-------------------------------------------------------"
    puts "*** NOTE ***"
    puts "- Ensure the #{sis_data.num_courses} Load Test Courses are PUBLISHED before running the JMeter test plan"
  end

  def update(var)
    puts "Updating server config"
    CSV.update_config_csv("server", "#{var["server_protocol"]},#{var["server_name"]},#{var["server_port"]},#{var["canvas_token"]}")
    puts "Updating test config"
    CSV.update_config_csv("test", "#{var["num_of_courses"]},#{var["jmeter_users"]},#{var["jmeter_loops"]},#{var["jmeter_ramp_up"]},#{var["jmeter_delay_constant"]},#{var["jmeter_delay_deviation"]}")
    courses = Canvas::Course.load_test_courses var["num_of_courses"]  
    puts "Updating course config"  
    CSV.update_config_csv("course","#{courses.first["id"]},#{courses.last["id"]}")
  end

  def discussions(var)
    puts "Creating Discussion Topic"
    num = 1
    courses = Canvas::Course.load_test_courses var["num_of_courses"]
    courses.each do |course|
      Canvas::Discussion.add course["id"], var["discussion_title"],var["discussion_message"]
      topic_id = Canvas::Discussion.topic_id course["id"], var["discussion_title"]
      CSV.update_data_csv("discussion", "#{course["id"]},#{topic_id}", num)
      num += 1
    end
  end

  def content(var)
    puts "Getting random content from Wikipedia"
    CSV.generate_random_content(var["num_of_users"])
  end

end