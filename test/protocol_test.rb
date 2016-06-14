require_relative 'test_helper'

module Gt06Server
  class ProtocolTest < MiniTest::Test

    def test_read_several_pack
      io = StringIO.new ['787808134B040300010011061F0D0A787825160B0B0F0E241DCF027AC8870C4657E60014020901CC00287D001F726506040101003656A40D0A'].pack('H*')

      first_pack = Protocol.read_pack(io)
      second_pack = Protocol.read_pack(io)
      assert_equal(first_pack.payload.packet_length, 8)
      assert_equal(second_pack.payload.packet_length, 37)
    end

    def test_reply_on_status_pack
      io = StringIO.new ['787808134B040300010011061F0D0A'].pack('H*')

      terminal_pack = Protocol.read_pack(io)
      server_pack = Protocol.replay_on(terminal_pack)

      assert_equal(server_pack.protocol_number, terminal_pack.payload.protocol_number)
      assert_equal(server_pack.serial_number, terminal_pack.payload.serial_number)
    end

    def test_reply_on_login_pack
      io = StringIO.new ['78780D01012345678901234500018CDD0D0A'].pack('H*')

      terminal_pack = Protocol.read_pack(io)
      server_pack = Protocol.replay_on(terminal_pack)

      assert_equal(server_pack.protocol_number, terminal_pack.payload.protocol_number)
      assert_equal(server_pack.serial_number, terminal_pack.payload.serial_number)
    end

    def test_reply_on_other_pack
      io = StringIO.new ['78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000373770D0A'].pack('H*')

      server_pack = Protocol.replay_on(Protocol.read_pack(io))

      assert_equal(server_pack, nil)
    end
  end
end

