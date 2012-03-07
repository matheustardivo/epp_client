require "spec_helper"

describe EppClient::Registrobr::Client do
  
  subject {
    EppClient::Registrobr::Client.new("beta.registro.br", 700)
  }
  
  it "should login" do
    subject.login.should_not be_empty
    
    # Preciso deixar isso automático
    subject.logout
    subject.close
  end
  
  it "should check domain" do
    subject.login.should_not be_empty
    subject.check("alisson15.com.br").should_not be_empty
    
    # validar frase Domínio já registrado
    # Preciso deixar isso automático
    subject.logout
    subject.close
  end
end
