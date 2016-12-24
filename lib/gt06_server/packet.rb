# frozen_string_literal: true
require 'bindata'

require_relative 'messages/date_time_information'
require_relative 'messages/gps_information'
require_relative 'messages/lbs_information'
require_relative 'messages/location_data'
require_relative 'messages/status_information'
require_relative 'messages/login_message'
require_relative 'messages/alarm_packet'
require_relative 'messages/gps_query_address'

module Gt06Server
  class TerminalPacket < BinData::Record
    class << self
      attr_reader :types

      def types
        {
            login_message:                 0x01,
            location_data:                 0x12,
            status_information:            0x13,
            string_information:            0x15,
            alarm_packet:                  0x16,
            gps_query_address_information: 0x1A,
            command_information:           0x80
        }
      end
    end

    # Data Packet Format
    # The communication is transferred asynchronously in bytes.
    #   The total length of packets is (10+N) Bytes.
    #   Format Length(Byte)
    # Start Bit 2
    # Packet Length 1
    # Protocol Number 1
    # Information Content N
    # Information Serial Number 2
    # Error Check 2
    # Stop Bit 2

    bit16 :start_bit, asserted_value: 0x7878
    struct :payload do
      bit8 :packet_length
      bit8 :protocol_number
      virtual :message_type, value: -> { TerminalPacket.types.key(protocol_number) }
      choice :information_content, selection: :protocol_number do
        # 4.3. Protocol Number
        # Type Value
        # Login Message 0x01
        # Location Data 0x12
        # Status information 0x13
        # String information 0x15
        # Alarm data 0x16
        # GPS, query address information by phone number 0x1A
        # Command information sent by the server to the terminal 0x80
        login_message(TerminalPacket.types[:login_message])
        location_data(TerminalPacket.types[:location_data])
        status_information(TerminalPacket.types[:status_information])
        alarm_packet(TerminalPacket.types[:alarm_packet])
        gps_query_address_information(TerminalPacket.types[:gps_query_address_information])
      end
      bit16 :serial_number
    end
    bit16 :error_check, assert_value: -> { calculate_crc }
    bit16 :stop_bit, asserted_value: 0x0D0A

    private

    def calculate_crc
      CRC16.calc(payload.to_binary_s)
    end
  end

  class ServerAckPacket < BinData::Record
    bit16 :start_bit, value: 0x7878
    bit8 :packet_length, value: 5
    bit8 :protocol_number
    bit16 :serial_number
    bit16 :error_check, value: lambda {
      CRC16.calc(packet_length.to_binary_s + protocol_number.to_binary_s + serial_number.to_binary_s)
    }
    bit16 :stop_bit, value: 0x0D0A
  end
end
