require 'digest/crc16_modbus'

module GalileoSkyServer
  class Pack < BinData::Record
    bit8le :header
    virtual assert: -> { header == 0x01 }
    bit16le :raw_len
    array :tags, read_until: -> { len <= array.num_bytes } do
      bit8le :tag
      string :data, length: -> { Tags.find_by_id(tag).length }
    end
    bit16le :crc
    virtual assert: -> { crc == calculated_crc }

    def archive?
      # Старший бит длины пакета является признаком наличия неотправленных данных в архиве, младшие
      # 15 число байт в пакете. Максимальная длина пакета 1000 байт.
      raw_len[15]
    end

    def payload
      result = []
      tmp_array = []
      tags.each do |tag|
        if tag.tag == 0x10 # Тег с номером строки данных, если встречаем этот тег, то доваляем новую строчку в результирующий массив
          tmp_array = []
          tmp_array << tag
          result << tmp_array
        else
          tmp_array << tag
        end
      end

      result << tmp_array if result.empty?

      result
    end

    def len
      raw_len & ((2**15) - 1)
    end

    def calculated_crc
      Digest::CRC16Modbus.checksum(to_binary_s[0..-3])
    end
  end

  class AcknowledgmentPack < BinData::Record
    bit8le :header, value: -> { 0x02 }
    bit16le :crc
  end
end
