require_relative 'test_helper'

module Gt06Server
  class Gp06ServerSessionKillerTest < MiniTest::Test
    def setup
    end

    def test_session_killer
      host = 'localhost'
      port = 3011

      Celluloid.boot

      server = Server.run(host,port, options:{session_timeout: 1, killer_interval: 1}).actors.first
      sleep 0.5

      socket = TCPSocket.new(host, port)
      sleep 0.1
      assert_equal(1, server.sessions.size)
      sleep 0.5
      assert_equal(1, server.sessions.size)
      sleep 1.5
      p server.sessions
      assert_equal(0, server.sessions.size)

      assert_raises Errno::ECONNRESET do
        socket.read
      end

      sleep 0.5
      Celluloid.shutdown
    end
  end
end

