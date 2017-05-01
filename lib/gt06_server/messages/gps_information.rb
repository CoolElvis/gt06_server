# frozen_string_literal: true

module Gt06Server
  module Messages
    class GpsInformation < BinData::Record
      # GPS Information
        # Date Time 6 0x0B 0x08 0x1D 0x11 0x2E 0x10
        # Quantity of GPS information satellites 1 0xCF
        # Latitude 4 0x02 0x7A 0xC7 0xEB
        # Longitude 4 0x0C 0x46 0x58 0x49
        # Speed 1 0x00
        # Course, Status 2 0x14 0x8F

      class Coord < BinData::Primitive
        uint32be :coord

        def get
          coord.to_f / 30_000 / 60
        end

        # TODO
        def set(value)
        end
      end

      struct :quantity_satellites do
        bit4 :length_gps
        bit4 :satellites
      end
      coord :latitude
      coord :longitude
      uint8 :speed
      struct :course_status do
        bit1 :null_1
        bit1 :null_2
        bit1 :gps_positioning_type  # GPS real-time/differential positioning
        bit1 :is_gps_positioning    # GPS having been positioning or not
        bit1 :longitude_bit         # East Longitude, West Longitude
        bit1 :latitude_bit          # South Latitude, North Latitude
        bit10 :course
      end
    end

    def lat
      latitude_bit ? latitude : (latitude * -1)
    end

    def lon
      longitude_bit ? longitude : (longitude * -1)
    end
  end
end
