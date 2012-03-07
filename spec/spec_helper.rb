require "bundler"
Bundler.setup(:default, :test)
Bundler.require

require "epp_client"

require "rake"
load File.expand_path("../../Rakefile", __FILE__)
