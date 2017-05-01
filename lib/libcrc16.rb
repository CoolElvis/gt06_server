# frozen_string_literal: true

require 'ffi'

module GetCrc16
  extend FFI::Library
  ffi_lib 'lib/libcrc_16.so'

  attach_function :get_crc16, [:string, :int], :int
end
