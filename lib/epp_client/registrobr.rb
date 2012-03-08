require 'epp_client/registrobr/client'

TEMPLATES_FOLDER = 'files/registrobr/templates/'
CERTIFICATES_FOLDER = 'files/registrobr/'

TEMPLATES = {
  :login => "#{TEMPLATES_FOLDER}login.xml.erb",
  :logout => "#{TEMPLATES_FOLDER}logout.xml.erb",
  :domain_check => "#{TEMPLATES_FOLDER}domain_check.xml.erb"
}

CERTIFICATES = {
  :cert => "#{CERTIFICATES_FOLDER}client.pem",
  :key => "#{CERTIFICATES_FOLDER}key.pem",
  :ca_file => "#{CERTIFICATES_FOLDER}root.pem"
}
