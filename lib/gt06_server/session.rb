module GalileoSkyServer
  class Session
    class SessionError < Exception; end

    attr_reader :device_info, :io

    def initialize(io)
      @io          = io
      @device_info = {}
    end

    # @raise EOF
    def run
      pack = handle_head_pack(Protocol.parse(@io))

      @io.write(Protocol.acknowledgment_pack(pack).to_binary_s)

      loop do
        main_pack = Protocol.parse(@io)

        Protocol.format_payload(main_pack.payload).each do |data_row|
          yield(data_row, @device_info)
        end

        @io.write(Protocol.acknowledgment_pack(main_pack).to_binary_s)
      end
    end

    # @param pack [Pack]
    # @raise SessionError
    # @return [Pack]
    def handle_head_pack(pack)
      payload = Protocol.format_payload(pack.payload)

      @device_info[:hardware_version] = payload[0][0x01][:val] # FIXME
      @device_info[:software_version] = payload[0][0x02][:val]
      @device_info[:imei]             = payload[0][0x03][:val]
      @device_info[:devise_id]        = payload[0][0x04][:val]

      # unless @device_info[:hardware_version] && @device_info[:software_version] && @device_info[:imei] && @device_info[:devise_id]
      #   raise SessionError, "Empty the required parameters: #{@device_info}"
      # end

      pack
    end
  end
end
