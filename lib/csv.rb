module CSV
  extend self

  def update_config_csv(type, data)
    file = File.dirname(__FILE__) + "/../config/#{type}_config.csv"

    begin
      csv_file = File.open(file, "w")
      csv_file.write data
    rescue IOError => e
      puts "ERROR: failed to create #{file}\n #{e.to_s}"
    ensure
      csv_file.close unless csv_file.nil?
    end
  end

  def erase_data_csv
    ["course", "assignment", "discussion"].each do |type|
      file = File.dirname(__FILE__) + "/../data/#{type}"
      begin
        FileUtils.rm_rf file
      rescue IOError => e
        puts "ERROR: failed to delete #{file}\n #{e.to_s}"
      end
    end
  end

  def update_data_csv(type, data, num=nil)
    if num.nil?
      file = File.dirname(__FILE__) + "/../data/#{type}/#{type}.csv"
    else
      file = File.dirname(__FILE__) + "/../data/#{type}/#{type}_#{num}.csv"
    end

    begin
      csv_file = File.open(file, "w")
      csv_file.write "#{data}"
    rescue IOError => e
      puts "ERROR: failed to create #{file}\n #{e.to_s}"
    ensure
      csv_file.close unless csv_file.nil?
    end
  end

  def generate_random_content(num_of_users)
    num = 1
    num_of_users.times do
      filename = File.dirname(__FILE__) + "/../data/content/content_#{num}.csv"
      begin
        file = File.open(filename, "w")
        file.write "#{Content::Wikipedia.random_title},#{Content::Wikipedia.random_content}"
      rescue IOError => e
        puts "ERROR: failed to create #{filename}}\n #{e.to_s}"
      ensure
        file.close unless file.nil?
      end
      num += 1
    end
  end

end