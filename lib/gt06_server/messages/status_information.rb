# frozen_string_literal: true

module Gt06Server
  module Messages
    # 5.3. Alarm Packet (Combined information packet of GPS, LBS and Status)
    # 5.3.1. Server Sending Alarm Data Packet to Server
    # Format Length (Byte)
    # Start Bit 2
    # Packet Length 1
    # Protocol Number 1
    ## Information content
    # Terminal Information Content 1
    # Voltage Level 1
    # GSM Signal Strength 1
    # Alarm/Language 2
    # Serial Number 2
    # Error Check 2
    # Stop Bit 2

    # 5.3.1.14. Terminal Information
    # One byte is consumed, defining various status information of the mobile phone.
    # Code Meaning
    # Bit7
    # 1: oil and electricity disconnected
    # 0: gas oil and electricity connected
    # Bit6
    # 1: GPS tracking is on
    # 0: GPS tracking is off
    # Bit3~ Bit5
    # 100: SOS
    # 011: Low Battery Alarm
    # 010: Power Cut Alarm
    # 001: Shock Alarm
    # 000: Normal
    # Bit2
    # 1: Charge On
    # 0: Charge Off
    # Bit1
    # 1: ACC high
    # 0: ACC Low
    # Bit0
    # 1: Defense Activated
    # 0: Defense Deactivated

    # 5.3.1.17. Alarm/Language
    # 0x00 (former bit) 0x01 (latter bit)
    # former bit: terminal alarm status (suitable for alarm packet and electronic fence project)
    # latter bit: the current language used in the terminal
    # former bit
    # 0x00: normal
    # 0x01: SOS
    # 0x02: Power Cut Alarm
    # 0x03: Shock Alarm
    # 0x04: Fence In Alarm
    # 0x05: Fence Out Alarm
    # latter bit
    # 0x01: Chinese
    # 0x02: English
    # Examples:
    # No Alarm and Language is Chinese: 0x00 0x01
    # No Alarm and Language is English: 0x00 0x02

    # Main record class
    class StatusInformation < BinData::Record
      # Primitive class
      class AlarmStatus < BinData::Primitive
        bit3 :alarm_status_bit

        def get
          [:normal, :shock, :power_cut, :low_battery, :sos][alarm_status_bit]
        end

        def set(value)
          self.alarm_status_bit = [:normal, :shock, :power_cut, :low_battery, :sos].index(value)
        end
      end

      # Primitive class
      class Alarm < BinData::Primitive
        bit8 :alarm_bit

        def get
          [:normal, :sos, :power_cut, :shock, :fence_in, :fence_out][alarm_bit]
        end

        # TODO
        def set(value)
        end
      end

      # Primitive class
      class Language < BinData::Primitive
        bit8 :language_bit

        def get
          { 0x01 => :english, 0x02 => :chinese }[language_bit]
        end

        # TODO
        def set(value)
        end
      end

      struct :terminal_information do
        bit1 :electricity_bit
        bit1 :gps_bit
        alarm_status :alarm_status
        bit1 :charge_bit
        bit1 :acc_bit
        bit1 :defense_bit
      end
      uint8 :voltage_level, length: 1
      uint8 :gsm_signal_strength, length: 1
      alarm :alarm
      language :language
    end
  end
end
