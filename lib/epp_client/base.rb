require 'yaml'

module EppClient
  extend self

  @@config = nil

  def config_file
    "config/epp_client.yml"
  end

  def config?
    File.exist?(config_file)
  end

  def config
    raise MissingConfigurationError, "file not found on #{config_file.inspect}" unless config?
    @@config ||= YAML.load(File.open(config_file))
  end
  
  def template(registrar, symbol)
    "#{config[registrar.to_s]['templates_path']}/#{config[registrar.to_s]['templates'][symbol.to_s]}"
  end

  def certificate(registrar, symbol)
    "#{config[registrar.to_s]['certificates_path']}/#{config[registrar.to_s]['certificates'][symbol.to_s]}"
  end
  
  class MissingEnvironmentError < StandardError; end
  class MissingConfigurationError < StandardError; end
end
