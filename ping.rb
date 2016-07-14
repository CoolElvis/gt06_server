# frozen_string_literal: true
require 'socket'

socket = TCPSocket.new('localhost', 5000)

socket.send(['78780D01012345678901234500018CDD0D0A'].pack('H*'), 0)
p socket.gets
socket.send(['78781F120B081D112E10CC027AC7EB0C46584900148F01CC00287D001FB8000373770D0A'].pack('H*'), 0)
socket.send(['787825160B0B0F0E241DCF027AC8870C4657E60014020901CC00287D001F726506040101003656A40D0A'].pack('H*'), 0)
socket.send(['787808134B040300010011061F0D0A'].pack('H*'), 0)
p socket.gets
p socket.gets
