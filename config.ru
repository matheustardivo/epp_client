require ::File.expand_path('../app',  __FILE__)

use Rack::ShowExceptions

run App.new
