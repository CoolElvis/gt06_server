# frozen_string_literal: true

require 'concurrent'

module Gt06Server
  class SessionSweeper
    attr_reader :sessions , :info, :timeout, :interval, :logger

    # @param sessions[Array<Session>]
    def initialize(sessions, timeout = 60, interval: 30, logger: Logger.new(STDOUT))
      @sessions = sessions
      @timeout  = timeout || 60
      @interval = interval || 30
      @info     = { killed: 0, live: 0, count: 0 }
      @logger   = logger
    end

    def run
      timer = Concurrent::TimerTask.new(execution_interval: @interval) do
        @sessions.each_pair do |key, session|
          next unless expired_session?(session)

          unless session.socket.closed?
            session.socket.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, [1, 0].pack('ii'))
            session.socket.close
          end

          @info[:killed] += 1
          @sessions.delete(key)
          @logger.debug "Session #{session.inspect} has been killed"
        end

        @info[:live] = @sessions.size
        @info[:count] += 1

        @info
      end

      timer.add_observer(SessionSweeperObserver.new(@logger))
      timer.execute
    end

    private

    def expired_session?(session)
      (session.info[:last_received_at] + @timeout) < Time.now
    end


    class SessionSweeperObserver
      def initialize(logger)
        @logger = logger
      end

      def update(time, result, exception)
        if result
          @logger.info "(#{time}) Execution successfully returned #{result}"
        else
          @logger.error "(#{time}) Execution failed with error #{exception}"
          @logger.error "(#{time}) #{exception.backtrace}"
          # Airbrake.notify(exception)
        end
      end
    end
  end
end
