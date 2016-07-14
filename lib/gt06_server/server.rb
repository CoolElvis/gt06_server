# frozen_string_literal: true
require 'celluloid/current'
require 'celluloid/io'
require 'logger'
require 'concurrent'

module Gt06Server
  class Server
    #TODO replace to an explicit logger

    attr_reader :host, :port, :options
    finalizer :shutdown

    class RunError < StandardError;
    end

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

    def initialize(host, port, handler, options: {} )

      @logger = options.fetch(:logger, Logger.new(STDOUT))
      @host   = host
      @port   = port

      @sessions = Concurrent::Map.new

      killer = SessionKiller.new(@sessions, session_timeout)
      killer.run

      @info = { killer_info: killer.info }

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
      begin
        addr = socket.peeraddr
        @logger.info "Connect #{addr}"

        session = Session.new(socket, logger: logger)
        @sessions[session.object_id] = session

        session.run(&handler)
      rescue EOFError => exception
        @logger.warn "#{addr}  #{exception.message}"
      rescue StandardError => exception
        @logger.error exception.message
        @logger.error exception.backtrace
      ensure
        socket.close if socket
        @logger.info "Disconnect #{addr}"
      end
    end
  end
end
