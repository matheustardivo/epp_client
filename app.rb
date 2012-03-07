require 'sinatra'
require 'albino'
require 'nokogiri'

require './lib/epp_client'
require './lib/epp_client/registrobr'
require './lib/epp_client/registrobr/client'

class App < Sinatra::Application
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
    
    def colorize(text, lang)
      doc = Nokogiri::XML(text, &:noblanks)
      Albino.colorize(doc, lang.to_sym)
    end
  end
  
  get '/' do
    client = EppClient::Registrobr::Client.new("beta.registro.br", 700)
    @login = client.login
    @check = client.check(params[:dominio])
    
    client.logout
    client.close
    
    erb :index
  end
end
