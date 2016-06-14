require 'celluloid/io'
require 'celluloid/autostart'
require 'logger'

module GalileoSkyServer
  class Server
    include Celluloid::IO
    include Celluloid::Internals::Logger

    attr_reader :host, :port
    finalizer :shutdown

    def initialize(host, port, log_file = nil, &block)
      Celluloid.logger = ::Logger.new(log_file || STDOUT)

      @host = host
      @port = port

      async.run block
    end

    private

    def run(block)
      @server = TCPServer.new(host, port)
      loop { async.handle_connection(@server.accept, block) }
    end

    def shutdown
      @server.close if @server
    end

    def handle_connection(socket, block)
      addr = socket.peeraddr
      info "Connect #{addr}"

      Session.new(socket).run(&block)

    rescue EOFError, StandardError => e
      warn "#{addr}  #{e.message}"
      socket.close if socket
      info "Disconnect #{addr}"
    end
  end
end
