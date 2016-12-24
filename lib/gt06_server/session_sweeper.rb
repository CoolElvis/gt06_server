require 'concurrent'

class SessionSweeper
  attr_reader :sessions , :info, :timeout, :interval, :logger

  def initialize(sessions, timeout = 60, interval: 30, logger: Logger.new(STDOUT))
    @sessions = sessions
    @timeout  = timeout
    @interval = interval
    @info     = {killed: 0, live:0, count:0}
    @logger   = logger
  end

  def run
    timer = Concurrent::TimerTask.new(execution_interval: @interval) do
      time_now = Time.now
      @sessions.each_pair do |key, session|
        if (session.info[:last_received_at] + @timeout) < time_now
          session.io.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, [1,0].pack('ii'))
          session.io.close

          @logger.debug "Session #{session.inspect} has been closed"

          @info[:killed] += 1
          @sessions.delete(key)
        end
      end

      @info[:live] = @sessions.size
      @info[:count] += 1

      @info
    end

    timer.add_observer(SessionSweeperObserver.new(@logger))
    timer.execute
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
