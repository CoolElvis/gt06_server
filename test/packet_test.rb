require_relative 'test_helper'

module Gt06Server
  class PacketTest < MiniTest::Test
    def test_crc
      data = "\x1f\x12\x10\x06\x1b\x0f\x08\x18\xc6\x06\x6c\x35\x3d\x03\x3c\xe9\x2c\x00\x35\x65\x00\xfa\x14\x4c\xfa\x00\x1d\xa9\x01\x07"
      assert_equal(CRC16.calc(data), "\xe2\x94".unpack('S>').first)
    end

    def test_login_packet
      # Login packet:
      # Example of data packet sent by the terminal 78 78 0D 01 01 23 45 67 89 01 23 45 00 01 8C DD 0D 0A
      # Explain
      # 0x78 0x78 Start Bit
      # 0x0D Length
      # 0x01 Protocol No
      # 0x01 0x23 0x45 0x67 0x89 0x01 0x23 0x45  Terminal ID
      # 0x00 0x01 Serial No
      # 0x8C 0xDD Error Check
      # 0x0D 0x0A Stop Bit

      io =  ['78780D01012345678901234500018CDD0D0A'].pack('H*')
      result = TerminalPacket.read(io)
      assert_equal(result.start_bit.to_hex, '7878' )
      assert_equal(result.payload.packet_length.to_hex, '0d' )
      assert_equal(result.payload.protocol_number.to_hex, '01' )
      assert_equal(result.payload.information_content.terminal_id.to_hex, '0123456789012345')
      assert_equal(result.payload.serial_number.to_hex, '0001')
      assert_equal(result.error_check.to_hex, '8cdd' )
      assert_equal(result.stop_bit.to_hex, '0d0a' )
    end

    def test_location_data
      # Location data packet:
      # Example of sending by the terminal
      # 78 78 1F 12 0B 08 1D 11 2E 10 CC 02 7A C7 EB 0C 46 58 49 00 14 8F 01 CC 00 28 7D 00 1F B8 00 03 80 81 0D 0A
      # Explain
      # 0x78 0x78 Start Bit
      # 0x1F Length
      # 0x12 Protocol No.
      # 0x0B 0x08 0x1D 0x11 0x2E 0x10 Date Time
      # 0xCC Quantity of GPS information satellites
      # 0x02 0x7A 0xC7 0xEB Latitude
      # 0x0C 0x46 0x58 0x49 Longitude
      # 0x00 Speed
      # 0x14 0x8F Course Status
      # 0x01 0xCC MCC
      # 0x00 MNC
      # 0x28 0x7D LAC
      # 0x00 0x1F 0xB8 Cell ID
      # 0x00 0x03 Serial No
      # 0x73 0x77 Error Check
      # 0x0D 0x0A Stop Bit

      io = ['78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000373770D0A'].pack('H*')
      pack = TerminalPacket.read(io)
      content = pack.payload.information_content

      assert_equal(content.date_time.to_hex, '0b081d112e10')
      assert_equal(content.gps.quantity_satellites.to_hex, 'cc')
      assert_equal(content.gps.latitude.to_hex, '027ac7eb')
      assert_equal(content.gps.latitude, 23.111668333333334)
      assert_equal(content.gps.longitude.to_hex, '0c465849')
      assert_equal(content.gps.longitude, 114.409285)
      assert_equal(content.gps.speed.to_hex, '00')
      assert_equal(content.gps.course_status.to_hex, '148f')
      assert_equal(content.lbs.mcc.to_hex, '01cc')
      assert_equal(content.lbs.mnc.to_hex, '00')
      assert_equal(content.lbs.lac.to_hex, '287d')
      assert_equal(content.lbs.cell_id.to_hex, '001fb8')
      assert_equal(pack.payload.serial_number, 3)
    end

    def test_alarm_packet
      io = ['787825160B0B0F0E241DCF027AC8870C4657E60014020901CC00287D001F726506040101003656A40D0A'].pack('H*')
      pack = TerminalPacket.read(io)
      content = pack.payload.information_content

      assert_equal(content.date_time.to_hex, '0b0b0f0e241d')
      assert_equal(content.gps.quantity_satellites.to_hex, 'cf')
      assert_equal(content.gps.latitude.to_hex, '027ac887')
      assert_equal(content.gps.longitude.to_hex, '0c4657e6')
      assert_equal(content.gps.speed.to_hex, '00')
      assert_equal(content.gps.course_status.to_hex, '1402')
      assert_equal(content.lbs.mcc.to_hex, '01cc')
      assert_equal(content.lbs.mnc.to_hex, '00')
      assert_equal(content.lbs.lac.to_hex, '287d')
      assert_equal(content.lbs.cell_id.to_hex, '001f72')
      assert_equal(content.status.terminal_information.to_hex, '65')
      assert_equal(content.status.terminal_information.electricity_bit, 0)
      assert_equal(content.status.terminal_information.gps_bit, 1)
      assert_equal(content.status.terminal_information.charge_bit, 1)
      assert_equal(content.status.terminal_information.acc_bit, 0)
      assert_equal(content.status.terminal_information.defense_bit, 1)
      assert_equal(content.status.terminal_information.alarm_status, :sos)
      assert_equal(content.status.voltage_level.to_hex, '06')
      assert_equal(content.status.gsm_signal_strength.to_hex, '04')
      assert_equal(content.status.alarm.to_hex, '01')
      assert_equal(content.status.alarm, :sos)
      assert_equal(content.status.language.to_hex, '01')
      assert_equal(content.status.language, :english)
      assert_equal(pack.payload.serial_number, 54)
    end

    def test_status_pack
      io = ['787808134B040300010011061F0D0A'].pack('H*')
      pack = TerminalPacket.read(io)
      content = pack.payload.information_content

      assert_equal(content.terminal_information.to_hex, '4b')
      assert_equal(content.terminal_information.electricity_bit, 0)
      assert_equal(content.terminal_information.gps_bit, 1)
      assert_equal(content.terminal_information.charge_bit, 0)
      assert_equal(content.terminal_information.acc_bit, 1)
      assert_equal(content.terminal_information.defense_bit, 1)
      assert_equal(content.terminal_information.alarm_status, :shock)
      assert_equal(content.voltage_level.to_hex, '04')
      assert_equal(content.gsm_signal_strength.to_hex, '03')
      assert_equal(content.alarm.to_hex, '00')
      assert_equal(content.alarm, :normal)
      assert_equal(content.language.to_hex, '01')
      assert_equal(content.language, :english)
      assert_equal(pack.payload.serial_number, 17)
    end


    def test_server_ack_pack
      packet = ServerAckPacket.new
      packet.serial_number = 1
      packet.protocol_number = 1

      assert_equal(packet.to_hex, '787805010001d9dc0d0a')
    end
  end
end

