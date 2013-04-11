require "yaml"
require "rest-client"

module Global
  extend self

  def from_yaml(file)
    YAML.load_file file
  end

  def from_json(url)
    JSON.parse  RestClient.get url
  end

end

