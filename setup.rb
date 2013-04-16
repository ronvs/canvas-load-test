require "yaml"
require "fileutils"
require_relative "lib/sis"
require_relative "lib/csv"
require_relative "lib/content"
require_relative "lib/global"
require_relative "lib/options"

if ARGV.empty?
  puts "Usage: ruby setup.rb < all | update | sis_imports | discussions | content > [url]"
  exit
end

if ARGV[1].nil?
  @var = Global.from_yaml File.dirname(__FILE__) + "/config/global_@variables.yml"
else
  @var = Global.from_json ARGV[1]
  Global.to_yaml_from_json ARGV[1]
end

Global.check_dir File.dirname(__FILE__) + "/data"
require_relative "lib/canvas"
sis_data = SIS.new(@var["num_of_courses"], @var["num_of_users"], @var["term_name"], @var["term_id"])

puts "Setting load test data on #{Canvas::Server.server}"
puts "-------------------------------------------------------"

if ARGV.first.eql? "all"
  Options.sis_imports sis_data
  Options.update @var
  Options.discussions @var
  Options.content @var
elsif ARGV.first.eql? "sis_imports"
  Options.sis_imports sis_data
elsif ARGV.first.eql? "discussions"
  Options.discussions @var
elsif ARGV.first.eql? "content"
  Options.content @var
elsif ARGV.first.eql? "update"
  Options.update @var
end

puts "Done"


