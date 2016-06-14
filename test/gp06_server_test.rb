require_relative 'test_helper'

module Gt06Server
  class Gp06ServerTest < MiniTest::Test
    def setup
    end



    # def test_session
    #   pseudo_io = StringIO.new @head_pack + @main_pack
    #   def pseudo_io.write(_arg); end
    #
    #   session = GalileoSkyServer::Session.new(pseudo_io)
    #
    #   assert_raises EOFError do
    #     session.run do |data_row, devise_info|
    #       assert_equal(devise_info, hardware_version: 10, software_version: 159, imei: '868204001293751', devise_id: 50)
    #       assert(!data_row.empty?)
    #     end
    #   end
    # end
    #
    # def test_server
    #   Celluloid.boot
    #
    #   GalileoSkyServer::Server.supervise as: :galileo_server, args: ['127.0.0.1', 3330] do |data, device_info|
    #     assert(!data.empty?)
    #     assert_equal device_info, hardware_version: 10, software_version: 159, imei: '868204001293751', devise_id: 50
    #   end
    #
    #   client = TCPSocket.new '127.0.0.1', 3330
    #   client.write @head_pack
    #
    #   assert_binary_equal("\x02\x1f\xc2", client.readpartial(4096))
    #   client.write @main_pack
    #   assert_binary_equal("\x02\xec\x7d", client.readpartial(4096))
    #
    #   Celluloid.shutdown
    # end
  end
end

