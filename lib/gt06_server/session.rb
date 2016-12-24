# frozen_string_literal: true
module Gt06Server
  class Session
    class SessionError < RuntimeError; end

    attr_reader :terminal_id, :io, :info, :logger, :addr

    def initialize(io, logger: Logger.new(STDOUT))
      @io          = io
      @addr        = io.peeraddr
      @terminal_id = ''
      @info        = { received_count: 0, sent_count: 0, last_received_at: Time.now}
      @logger      = logger

      logger.debug 'New session has been created'
    end

    # @yield [Hash] information_content of packet
    # @raise EOF
    def run(&block)
      handle_head_pack(Protocol.read_pack(@io))

      loop do
        handle_main_pack(Protocol.read_pack(@io), &block)
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
      @io.write(Protocol.replay_on(pack).to_binary_s)
      @info[:sent_count] += 1

      logger.debug "terminal_id: #{@terminal_id} , info #{@info}"
    end

    def handle_main_pack(pack, &block)
      logger.debug "terminal_id: #{@terminal_id} , info #{@info}, message: #{pack}"
      @info[:received_count] += 1
      @info[:last_received_at] = Time.now


      block.yield(pack.payload)

      ack_pack = Protocol.replay_on(pack)
      if (ack_pack)
        @io.write(ack_pack.to_binary_s)
        @info[:sent_count] += 1
      end
    end
  end
end
