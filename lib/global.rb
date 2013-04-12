require "yaml"
require "rest-client"
require "csv"

module Global
  extend self

  def from_yaml(file)
    YAML.load_file file
  end

  def to_yaml_from_json(url)
    var = JSON.parse RestClient.get url
    data = "server_protocol: \"#{var["server_protocol"]}\"\n
            server_port: #{var["server_port"]}\n
            server_name: \"#{var["server_name"]}\"\n
            canvas_token: \"#{var["canvas_token"]}\"\n
            canvas_account_id: #{var["canvas_account_id"]}\n
            term_id: \"#{var["term_id"]}\"\n
            term_name: \"#{var["term_name"]}\"\n
            discussion_title: \"#{var["discussion_title"]}\"\n
            discussion_message: \"#{var["discussion_message"]}\"\n
            assignment_name: \"#{var["assignment_name"]}\"\n
            assignment_description: \"#{var["assignment_description"]}\"\n
            num_of_courses: #{var["num_of_courses"]}\n
            num_of_users: #{var["num_of_users"]}\n
            jmeter_users: #{var["jmeter_users"]}\n
            jmeter_loops: #{var["jmeter_loops"]}\n
            jmeter_ramp_up: #{var["jmeter_ramp_up"]}\n
            jmeter_delay_constant: #{var["jmeter_delay_constant"]}\n
            jmeter_delay_deviation: #{var["jmeter_delay_deviation"]}\n"

    file = File.dirname(__FILE__) + "/../config/global_variables.yml"
    begin
      yml_file = File.open(file, "w")
      yml_file.write data
    rescue IOError => e
      puts "ERROR: failed to create #{yml_file}\n #{e.to_s}"
    ensure
      yml_file.close unless yml_file.nil?
    end
  end

  def from_json(url)
    JSON.parse RestClient.get url
  end

end

