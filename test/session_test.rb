require_relative 'test_helper'

module Gt06Server
  class SessionTest < MiniTest::Test
    def test_handle_head_pack
      login_pack = TerminalPacket.read(['78780D01012345678901234500018CDD0D0A'].pack('H*'))
      location_pack = TerminalPacket.read(['78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000373770D0A'].pack('H*'))

      mock_protocol = MiniTest::Mock.new
      mock_protocol.expect(:write, true, [Protocol.replay_on(login_pack).to_binary_s])
      mock_protocol.expect(:peeraddr, 'true')

      mock_read_pack = MiniTest::Mock.new
      mock_read_pack.expect(:call, login_pack, [mock_protocol])
      mock_read_pack.expect(:call, location_pack, [mock_protocol])
      mock_read_pack.expect(:call, nil) do
        raise EOFError
      end

      Protocol.stub(:read_pack, mock_read_pack) do
        session = Session.new(mock_protocol)
        sleep 1
        assert_raises EOFError do
          session.run do |content|
           assert_equal(content,location_pack.payload.snapshot.merge!(terminal_id: '0123456789012345'))
          end
        end

        assert_equal(Time.now.to_s, session.info[:last_received_at].to_s)
      end

      mock_protocol.verify
      mock_read_pack.verify
    end

    def test_incorrect_sequence
      io = StringIO.new(['787808134B040300010011061F0D0A'].pack('H*'))
      def io.peeraddr
        'localhost'
      end

      session = Session.new(io)
      assert_raises Session::SessionError do
        session.run
      end
    end

    def test_terminal_id
      io = StringIO.new(['78780D01012345678901234500018CDD0D0A78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000373770D0A'].pack('H*'))
      def io.peeraddr
        'localhost'
      end

      def io.write(*args)
      end

      session = Session.new(io)
      assert_raises EOFError do
        session.run do |message|
          assert_equal('0123456789012345', message[:terminal_id])
        end
      end
    end
  end
end

