# Server for gps tracker GT06(TK100)

[![Code Climate](https://codeclimate.com/github/CoolElvis/gt06_server/badges/gpa.svg)](https://codeclimate.com/github/CoolElvis/gt06_server)
[![Test Coverage](https://codeclimate.com/github/CoolElvis/gt06_server/badges/coverage.svg)](https://codeclimate.com/github/CoolElvis/gt06_server/coverage)
[![Issue Count](https://codeclimate.com/github/CoolElvis/gt06_server/badges/issue_count.svg)](https://codeclimate.com/github/CoolElvis/gt06_server)
[![Build Status](https://travis-ci.org/CoolElvis/gt06_server.svg?branch=master)](https://travis-ci.org/CoolElvis/gt06_server)


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gt06_server'
```

And then execute:

    $ bundle

## Usage

````ruby 
require 'gt06_server'

log_path = File.expand_path(File.join(File.dirname(__FILE__), 'log/server.log'))

Gt06Server::Server.run('0.0.0.0', 9000, options: { logger: Logger.new(log_path) }) do |message|
  p message
end

sleep

````

The message is a Hash like:  

````ruby 
{ 
  :packet_length       => 10,
  :protocol_number     => 19,
  :message_type        => :status_information,
  :information_content =>
    { 
      :terminal_information =>
        {
          :electricity_bit => 0,
          :gps_bit         => 0,
          :alarm_status    => :normal,
          :charge_bit      => 1,
          :acc_bit         => 0,
          :defense_bit     => 1
        },
      :voltage_level        => 0,
      :gsm_signal_strength  => 100,
      :alarm                => :normal,
      :language             => :english
    },
  :serial_number       => 48
}
````
The content of 'information_content' depends on 'message_type'
See lib/gt06_server/messages for details  
