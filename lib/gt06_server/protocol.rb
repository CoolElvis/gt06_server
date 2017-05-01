# frozen_string_literal: true

module Gt06Server
  module Protocol
    module_function

    # @param io [IO]
    # @return pack [TerminalPacket]
    def read_pack(io)
      TerminalPacket.read(io)
    end

    # @param pack [TerminalPacket]
    # @return [ServerAckPacket, nil]
    def replay_on(pack)
      if [:login_message, :status_information].include?(pack.payload.message_type.to_sym)
        acknowledgment_pack_for(pack)
      end
    end

    # @param pack [TerminalPacket]
    # @return pack [ServerAckPacket]
    def acknowledgment_pack_for(pack)
      ack_pack = ServerAckPacket.new
      ack_pack.protocol_number = pack.payload.protocol_number
      ack_pack.serial_number = pack.payload.serial_number

      ack_pack
    end

    # TODO
    def command_pack(command)
    end
  end
end
