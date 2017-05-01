# frozen_string_literal: true

module Gt06Server
  module Messages
    class LocationData < BinData::Record
      # 5.2. Location Data Packet (combined information package of GPS and LBS)
      # 5.2.1. Terminal Sending Location Data Packet to Server
      # Format Length(Byte) Example
        # Start Bit 2 0x78 0x78
        # Packet Length 1 0x1F
        # Protocol Number 1 0x12
        # Date Time 6 0x0B 0x08 0x1D 0x11 0x2E 0x10
          # GPS Information
            # Quantity of GPS information satellites 1 0xCF
            # Latitude 4 0x02 0x7A 0xC7 0xEB
            # Longitude 4 0x0C 0x46 0x58 0x49
            # Speed 1 0x00
            # Course, Status 2 0x14 0x8F
          # LBS Information
            # MCC 2 0x01 0xCC
            # MNC 1 0x00
            # LAC 2 0x28 0x7D
            # Cell ID 3 0x00 0x1F 0xB8
        # Serial Number 2 0x00 0x03
        # Error Check 2 0x80 0x81
        # Stop Bit 2 0x0D 0x0A

      date_time_information :date_time
      gps_information :gps
      lbs_information :lbs
    end
  end
end
