#!/Users/santos/.rvm/rubies/ruby-1.9.3-p286/bin/ruby

require "fileutils"
require "yaml"

var = YAML.load_file File.dirname(__FILE__) + "/config/global_variables.yml"

if File.directory? var["content_dir"]
  begin
    puts "Deleting all files from '#{var["content_dir"]}'"
    FileUtils.rm_rf "#{var["content_dir"]}"
  rescue IOError => e
    puts "ERROR: failed to delete files within #{var["content_dir"]}\n #{e.to_s}"
  end
else
  puts "ERROR: #{var["content_dir"]} is missing or not a directory."
end