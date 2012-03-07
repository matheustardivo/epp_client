module EppClient
  module Registrobr
    class Client
      def initialize(host, port)
        ssl_context = OpenSSL::SSL::SSLContext.new(:TLSv1)
        ssl_context.cert = OpenSSL::X509::Certificate.new(File.open('files/registrobr/client.pem'))
        ssl_context.key = OpenSSL::PKey::RSA.new(File.open('files/registrobr/key.pem'))
        ssl_context.ca_file = 'files/registrobr/root.pem'
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        @ssl_socket = OpenSSL::SSL::SSLSocket.new(
          TCPSocket.new(host, port), ssl_context)
        @ssl_socket.sync_close = true
        @ssl_socket.connect
        
        begin
          @ssl_socket.post_connection_check(host)
        rescue => ex
          raise PostConnectionCheckError, "Post connection check failed: #{ex.inspect}"
        end
        
        # puts @ssl_socket.peer_cert_chain.inspect
        @ssl_socket.sysread(4096)
      end
      
      def close
        @ssl_socket.close
      end

      def login
        xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0
     epp-1.0.xsd">
  <command>
    <login>
      <clID>117</clID>
      <pw>UYVQKIWPCQ</pw>
      <options>
        <version>1.0</version>
        <lang>pt</lang>
      </options>
      <svcs>
        <objURI>urn:ietf:params:xml:ns:domain-1.0</objURI>
        <objURI>urn:ietf:params:xml:ns:contact-1.0</objURI>
        <svcExtension>
          <extURI>urn:ietf:params:xml:ns:brdomain-1.0</extURI>
          <extURI>urn:ietf:params:xml:ns:brorg-1.0</extURI>
          <extURI>urn:ietf:params:xml:ns:secDNS-1.0</extURI>
          <extURI>urn:ietf:params:xml:ns:secDNS-1.1</extURI>
        </svcExtension>
      </svcs>
    </login>
    <clTRID>#{generate_uuid}</clTRID>
  </command>
</epp>
XML
        send_request(xml)
      end
      
      def logout
        xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0" 
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
     xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0 
     epp-1.0.xsd">
  <command>
    <logout/>
    <clTRID>#{generate_uuid}</clTRID>
  </command>
</epp>
XML
        send_request(xml)
      end
      
      def check(domain)
        xml = <<XML
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<epp xmlns="urn:ietf:params:xml:ns:epp-1.0"
     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
     xsi:schemaLocation="urn:ietf:params:xml:ns:epp-1.0
     epp-1.0.xsd">
  <command>
    <check>
      <domain:check
       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0"
       xsi:schemaLocation="urn:ietf:params:xml:ns:domain-1.0
       domain-1.0.xsd">
        <domain:name>#{domain}</domain:name>
      </domain:check>
    </check>
    <clTRID>#{generate_uuid}</clTRID>
  </command>
</epp>
XML
        send_request(xml)
      end
      
      private
      def send_request(xml)
        send_frame(xml)
        get_frame
      end
      
      def generate_uuid
        UUID.generate(:compact)
      end
      
      def send_frame(xml)
        @ssl_socket.write(packed(xml) + xml)
      end
      
      def packed(xml)
        [xml.size + 4].pack("N")
      end
      
      def get_frame
        raise SSLSocketError, "Connection closed by remote server" if !@ssl_socket or @ssl_socket.eof?
        
        header = @ssl_socket.read(4)
        raise SSLSocketError, "Error reading frame from remote server" if header.nil?
        
        length = header_size(header)
        raise SSLSocketError, "Got bad frame header length of #{length} bytes from the server" if length < 5
        
        @ssl_socket.read(length - 4)
      end
      
      def header_size(header)
        header.unpack("N").first
      end
      
      class PostConnectionCheckError < StandardError; end
      class SSLSocketError < StandardError; end
    end
  end
end
