module Gt06Server
  module Messages
    class AlarmPacket < BinData::Record
        # 5.3. Alarm Packet (Combined information packet of GPS, LBS and Status)
        # 5.3.1. Server Sending Alarm Data Packet to Server
        # Format Length (Byte)
        # Start Bit 2
        # Packet Length 1
        # Protocol Number 1
        # Date Time 6
          # GPS Information
            # Quantity of GPS information satellites 1
            # Latitude 4
            # Longitude 4
            # Speed 1
            # Course, Status 2
            # LBS Information
          # LBS Length 1
            # MCC 2
            # MNC 1
            # LAC 2
            # Cell ID 3
          # status Information
            # Terminal Information Content 1
            # Voltage Level 1
            # GSM Signal Strength 1
            # Alarm/Language 2
        # Serial Number 2
        # Error Check 2
        # Stop Bit 2

      date_time_information :date_time
      gps_information :gps
      string :lbs_length, length: 1
      lbs_information :lbs
      status_information :status
    end
  end
end

