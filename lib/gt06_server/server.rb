# frozen_string_literal: true

require 'celluloid/current'
require 'celluloid/io'
require 'logger'
require 'concurrent'

module Gt06Server
  class Server
    include Celluloid::IO

    attr_reader :host, :port, :sessions
    finalizer :shutdown

    class RunError < StandardError; end

    # @param [String] host
    # @param [Integer] port
    # @param [Hash] options
    # @yields [Hash] information_content of packet
    def self.run(host, port, options: {}, &block)
      if Celluloid::Actor['Gt06Server']&.alive?
        raise RunError, 'Attempt to run more than one the Gt06Server'
      end

      Gt06Server::Server.supervise(
        as:   'Gt06Server',
        args: [host, port, block, options: { logger: Logger.new(STDOUT) }.merge(options)]
      )
    end

    def initialize(host, port, handler, options: {})
      @logger   = options.fetch(:logger, Logger.new(STDOUT))
      @host     = host
      @port     = port
      @sessions = Concurrent::Map.new

      sessions_sweeper_run(@sessions, options)
      async.run handler
    end

    private

    def run(handler)
      @server = TCPServer.new(@host, @port)
      @logger.info "Gt06Server has been run on host:#{@host} port: #{@port}"
      loop { async.handle_connection(@server.accept, handler) }
    end

    def sessions_sweeper_run(sessions, options)
      SessionSweeper.new(
        sessions,
        timeout:  options.fetch(:session_timeout, nil),
        interval: options.fetch(:sweep_interval, nil),
        logger:   options.fetch(:logger, Logger.new(STDOUT))
      ).run
    end

    def shutdown
      @server&.close
    end

    def handle_connection(socket, handler)
      addr = socket.peeraddr
      @logger.info "Connect #{addr}"

      session                      = Session.new(socket, logger: @logger)
      @sessions[session.object_id] = session

      session.run(&handler)
    rescue EOFError => exception
      @logger.warn "#{addr}  #{exception.message}"
    rescue StandardError => exception
      @logger.error exception.message
      @logger.error exception.backtrace
    ensure
      socket&.close
      @logger.info "Disconnect #{addr}"
    end
  end
end
