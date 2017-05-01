# frozen_string_literal: true

module Gt06Server
  module Messages
    class LbsInformation < BinData::Record
      # LBS Information
        # MCC 2 0x01 0xCC
        # MNC 1 0x00
        # LAC 2 0x28 0x7D
        # Cell ID 3 0x00 0x1F 0xB8

      uint16be :mcc
      uint8 :mnc
      uint16be :lac
      uint24be :cell_id
    end
  end
end
