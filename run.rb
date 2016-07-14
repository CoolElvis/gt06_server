# frozen_string_literal: true
require_relative 'lib/gt06_server'

log_path = File.expand_path(File.join(File.dirname(__FILE__), 'logs/server.log'))

Gt06Server::Server.run '0.0.0.0', 9001, logger: Logger.new(log_path) do |message|
  p message
end

sleep
