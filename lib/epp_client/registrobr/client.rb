module EppClient
  module Registrobr
    class Client
      attr_accessor :host, :port
      
      def initialize(host, port)
        @host, @port = host, port
      end
      
      def check(domain)
        @domain = domain
        
        connect
        login
        
        check_response = send_request(:domain_check)
        
        logout
        close_connection
        
        check_response
      end
      
      private
      def connect
        ssl_context = OpenSSL::SSL::SSLContext.new(:TLSv1)
        ssl_context.cert = OpenSSL::X509::Certificate.new(File.open(EppClient.certificate(:registrobr, :cert)))
        ssl_context.key = OpenSSL::PKey::RSA.new(File.open(EppClient.certificate(:registrobr, :key)))
        ssl_context.ca_file = EppClient.certificate(:registrobr, :ca_file)
        ssl_context.verify_mode = OpenSSL::SSL::VERIFY_NONE
        
        @ssl_socket = OpenSSL::SSL::SSLSocket.new(TCPSocket.new(@host, @port), ssl_context)
        @ssl_socket.sync_close = true
        
        @ssl_socket.connect
        
        begin
          @ssl_socket.post_connection_check(host)
        rescue => ex
          raise PostConnectionCheckError, "Post connection check failed: #{ex.inspect}"
        end
        
        @ssl_socket.sysread(4096)
      end
      
      def close_connection
        @ssl_socket.close
      end
      
      def login
        send_request(:login)
      end
      
      def logout
        send_request(:logout)
      end
      
      def send_request(xml)
        template_file = EppClient.template(:registrobr, xml)
        raise TemplateNotFoundError unless template_file
        
        actual_template = ERB.new File.open(template_file).readlines.join
        @uuid = generate_uuid
        
        send_frame(actual_template.result(binding))
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
      class TemplateNotFoundError < StandardError; end
    end
  end
end
