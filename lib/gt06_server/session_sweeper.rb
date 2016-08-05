require 'concurrent'

class SessionSweeper
  attr_reader :sessions , :info, :timeout, :interval

  def initialize(sessions, timeout = 60, interval: 30)
    @sessions = sessions
    @timeout  = timeout
    @interval = interval
    @info     = {killed: 0, live:0, count:0}
  end

  def run
    timer = Concurrent::TimerTask.new(execution_interval: @interval) do
      time_now = Time.now
      @sessions.each_pair do |key, session|
        if (session.info[:last_received_at] + @timeout) < time_now
          session.io.setsockopt(Socket::SOL_SOCKET, Socket::SO_LINGER, [1,0].pack('ii'))
          session.io.close
          puts "Session #{session} has been closed"
          @info[:killed] += 1
          @sessions.delete(key)
        end
      end

      @info[:live] = @sessions.size
      @info[:count] += 1
    end

    timer.execute
  end

end
