class SIS
  attr_accessor :num_courses, :num_users, :term_name, :term_id

  def initialize(num_courses, num_users, term_name, term_id)
    @num_courses = num_courses
    @num_users = num_users
    @term_name = term_name
    @term_id = term_id
  end

  def terms
    term_arr = []
    term_arr.push "term_id,name,status,start_date,end_date"
    term_arr.push "#{term_id},#{term_name},active,,"
    term_arr.join("\n")
  end

  def courses
    course_arr = []
    course_arr.push "course_id,short_name,long_name,account_id,term_id,status,2013-01-01"
    x = 1
    num_courses.times do
      course_arr.push "load-test-#{x},Load Test Course #{x},Load Test Course #{x},#{Canvas::Server.account_id},#{term_id},active"
      x += 1
    end
    course_arr.join("\n")
  end

  def users
    user_arr = []
    user_arr.push "user_id,login_id,password,first_name,last_name,email,status"
    x = 1
    num_users.times do
      user_arr.push "load_user#{x},load_user#{x},load_password#{x},Load#{x},Tester#{x},load#{x}@test.sfu.ca,active"
      x += 1
    end
    user_arr.join("\n")
  end

  def enrollments
    enrollment_arr = []
    enrollment_arr.push "course_id,user_id,role,section_id,status"
    y = 1
    num_courses.times do
      x= 1
      num_users.times do
        if x < 11
          # first 10 users are teachers
          line = "load-test-#{y},load_user#{x},teacher,,active"
        elsif x < 21
          # second 10 users are tas
          line = "load-test-#{y},load_user#{x},ta,,active"
        else
          line = "load-test-#{y},load_user#{x},student,,active"
        end
        enrollment_arr.push line
        x += 1
      end
      y += 1
    end
    enrollment_arr.join("\n")
  end

end