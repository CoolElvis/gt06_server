module Gt06Server
  module Messages
    class DateTimeInformation < BinData::Primitive
      # 5.2.1.4. Date Time
      # Format Length(Byte) Example
      # Year 1 0x0A
      # Month 1 0x03
      # Day 1 0x17
      # Hour 1 0x0F
      # Minute 1 0x32
      # Second 1 0x17
      # Example: 2010-03-23 15:30:23
      # Calculated as follows: 10(Decimal)=0A(Hexadecimal)
      # 3 (Decimal)=03(Hexadecimal)
      # 23(Decimal)=17(Hexadecimal)

      uint8 :year
      uint8 :month
      uint8 :day
      uint8 :hour
      uint8 :minute
      uint8 :second

      def get
        Time.new year + 2000, month, day, hour, minute, second
      end

      # TODO
      def set(value)
      end
    end
  end
end
