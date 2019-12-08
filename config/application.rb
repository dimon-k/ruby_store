require 'yaml'
require 'sequel'

db_config_file = File.join(File.dirname(__FILE__), 'database.yml')
if File.exist?(db_config_file)
  config = YAML.load(File.read(db_config_file))
  DB = Sequel.connect(config)
end
