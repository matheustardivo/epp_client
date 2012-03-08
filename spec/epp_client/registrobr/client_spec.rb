require "spec_helper"

describe EppClient::Registrobr::Client do
  
  subject {
    EppClient::Registrobr::Client.new("beta.registro.br", 700)
  }
  
  it "should check domain" do
    subject.check("alisson15.com.br").should_not be_nil
  end
end
