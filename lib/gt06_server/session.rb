# frozen_string_literal: true
module Gt06Server
  class Session
    class SessionError < RuntimeError; end

    attr_reader :terminal_id, :socket, :info, :logger, :addr

    # @param socket [TCPSocket]
    def initialize(socket, logger: Logger.new(STDOUT))
      @socket      = socket
      @addr        = socket.peeraddr
      @terminal_id = ''
      @info        = { received_count: 0, sent_count: 0, last_received_at: Time.now}
      @logger      = logger

      logger.debug 'New session has been created'
    end

    # @yield [Hash] information_content of packet
    # @raise EOF
    def run(&block)
      handle_head_pack(Protocol.read_pack(@socket))

      loop do
        handle_main_pack(Protocol.read_pack(@socket), &block)
      end
    end

    def inspect
      "#{object_id} Terminal id:#{@terminal_id}, ip: #{@addr}, #{@info}"
    end

    private

    def handle_head_pack(pack)
      if pack.payload.message_type != :login_message
        raise SessionError, 'Expect login message first but received: ' + pack.to_hex
      end

      @terminal_id = pack.payload.information_content.terminal_id.to_hex
      @info[:received_count] += 1
      @socket.write(Protocol.replay_on(pack).to_binary_s)
      @info[:sent_count] += 1

      logger.debug "terminal_id: #{@terminal_id} , info #{@info}"
    end

    def handle_main_pack(pack, &block)
      logger.debug "terminal_id: #{@terminal_id} , info #{@info}, message: #{pack}"
      @info[:received_count] += 1
      @info[:last_received_at] = Time.now


      block.yield(pack.payload)

      ack_pack = Protocol.replay_on(pack)
      if ack_pack
        @socket.write(ack_pack.to_binary_s)
        @info[:sent_count] += 1
      end
    end
  end
end
