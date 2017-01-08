require_relative 'test_helper'

module Gt06Server
  class CommandTest < MiniTest::Test

    def test_pub_command_to_redis
      require "redis"

      redis = Redis.new
      Future
    end

    def test_read_several_pack
      io = StringIO.new ['787808134B040300010011061F0D0A787825160B0B0F0E241DCF027AC8870C4657E60014020901CC00287D001F726506040101003656A40D0A'].pack('H*')

      first_pack = Protocol.read_pack(io)
      second_pack = Protocol.read_pack(io)
      assert_equal(first_pack.payload.packet_length, 8)
      assert_equal(second_pack.payload.packet_length, 37)
    end


  end
end

