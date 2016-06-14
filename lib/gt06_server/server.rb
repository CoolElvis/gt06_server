require 'celluloid/current'
require 'celluloid/io'
require 'logger'

module Gt06Server
  class Server
    include Celluloid::IO

    attr_reader :host, :port, :logger
    finalizer :shutdown

    class RunError < StandardError; end

    # @param [String] host
    # @param [Integer] port
    # @param [Logger] logger
    # @yields [Hash] information_content of packet
    def self.run(host, port, logger: Logger.new(STDOUT), &block)
      actor = Celluloid::Actor['Gt06Server']

      if actor&.alive?
        raise RunError, 'Attempt to run more than one the Gt06Server'
      end

      Gt06Server::Server.supervise(
        as:   'Gt06Server',
        args: [host, port, block, logger: logger]
      )
    end


    def initialize(host, port, handler, logger: Logger.new(STDOUT))
      @logger = logger
      @host = host
      @port = port

      async.run handler
    end

    private

    def run(handler)
      @server = TCPServer.new(@host, @port)
      @logger.info "Gt06Server has been run on host:#{@host} port: #{@port} "
      loop { async.handle_connection(@server.accept, handler) }
    end

    def shutdown
      @server.close if @server
    end

    def handle_connection(socket, handler)
      addr = socket.peeraddr
      @logger.info "Connect #{addr}"

      Session.new(socket, logger: logger).run(&handler)

    rescue EOFError => exception
      @logger.warn "#{addr}  #{exception.message}"
      socket.close if socket
      @logger.info "Disconnect #{addr}"

    rescue StandardError => exception
      socket.close if socket
      @logger.info "Disconnect #{addr}"
      @logger.error exception.message
      @logger.error exception.backtrace
    end
  end
end
