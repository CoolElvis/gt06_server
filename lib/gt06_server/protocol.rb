module GalileoSkyServer
  # Maybe it is not necessary abstraction
  module Protocol
    module_function

    def parse(io)
      Pack.read(io)
    end

    # @param pack [GalileoSkyServer::Pack]
    def acknowledgment_pack(pack)
      ack_pack = AcknowledgmentPack.new pack
      ack_pack.crc = pack.calculated_crc

      ack_pack
    end

    def format_payload(payload)
      result = []
      payload.each do |row|
        result_row = {}
        row.each do |tag|
          tag_meta = Tags.find_by_id(tag.tag)
          result_row[tag.tag.to_i] = { val: tag_meta.formatter.call(tag.data), desc: tag_meta.desc }
        end
        result << result_row
      end

      result
    end
  end
end
