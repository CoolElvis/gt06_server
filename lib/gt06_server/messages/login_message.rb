# frozen_string_literal: true
module Gt06Server
  module Messages
    class LoginMessage < BinData::Record
      # 5.1. Login Message Packet
      # 5.1.1. Terminal Sending Data Packet to Server
      # The login message packet is used to be sent to the server with the terminal ID so as to confirm the
      # established connection is normal or not.
      # Description Bits Example
        # Login Message Packet(18 Byte)
        # Start Bit 2 0x78 0x78
        # Packet Length 1 0x0D
        # Protocol Number1 0x01
        # Terminal ID 8 0x01 0x23 0x45 0x67 0x89 0x01 0x23 0x45
        # Information SerialNumber 2 0x00 0x01
        # Error Check 2 0x8C 0xDD
        # Stop Bit 2 0x0D 0x0

      uint64be :terminal_id
    end
  end
end
