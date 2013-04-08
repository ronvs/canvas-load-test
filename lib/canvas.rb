require "rest-client"
require "json"
require "yaml"

module Canvas

  module Server
    extend self
    @var = YAML.load_file File.dirname(__FILE__) + "/../config/global_variables.yml"

    def canvas_oauth_token
      @var["canvas_token"]
    end

    def account_id
      @var["canvas_account_id"]
    end

    def server
      "#{@var["server_protocol"]}://#{@var["server_name"]}:#{@var["server_port"]}"
    end

    def auth_header
      "Bearer #{canvas_oauth_token}"
    end

    def per_page
      200
    end

    def canvas_sis_import_url
      "#{server}/api/v1/accounts/#{account_id}/sis_imports.json?extension=csv"
    end

    def discussion_topic_url(course_id)
      "#{server}/api/v1/courses/#{course_id}/discussion_topics"
    end

    def assignment_url(course_id)
      "#{server}/api/v1/courses/#{course_id}/assignments"
    end

    def users_url
      "#{server}/api/v1/accounts/#{account_id}/users"
    end

    def sis_import(csv_data)
      post_to_canvas canvas_sis_import_url, csv_data
    end

    def post_to_canvas(url, data)
      RestClient.post url, data, :Authorization => auth_header
    end

    def get_from_canvas(url, json=true)
      if json
        JSON.parse  RestClient.get url, :Authorization => auth_header
      else
        RestClient.get url, :Authorization => auth_header
      end

    end
  end

  module Course
    extend self

    def load_test_courses(num_courses)
      num = 1
      course_ids_arr = []
      num_courses.times do
        url = "#{Canvas::Server.server}/api/v1/courses/sis_course_id:load-test-#{num}"
        course_ids_arr.push Canvas::Server.get_from_canvas url, true
        num += 1
      end
      course_ids_arr
    end

  end

  module Discussion
    extend self

    def add(course_id, title, message)
      data = {
          'title' => title,
          'message' => message
      }
      Canvas::Server.post_to_canvas Canvas::Server.discussion_topic_url(course_id), data
    end

    def topic_id(course_id, title)
      id = ""
      topics = Canvas::Server.get_from_canvas Canvas::Server.discussion_topic_url(course_id), true
      topics.each do |topic|
        id = topic["id"] if topic["title"].to_s.eql? title
      end
      id
    end

  end

end