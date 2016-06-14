module Gt06Server
  module Messages
    class LbsInformation < BinData::Record
      # LBS Information
        # MCC 2 0x01 0xCC
        # MNC 1 0x00
        # LAC 2 0x28 0x7D
        # Cell ID 3 0x00 0x1F 0xB8

      string :mcc, read_length: 2
      string :mnc, read_length: 1
      string :lac, read_length: 2
      string :cell_id, read_length: 3
    end
  end
end
