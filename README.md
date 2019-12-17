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

Status message:  

````ruby 
{ 
  :packet_length       => 10,
  :protocol_number     => 19,
  :message_type        => :status_information,
  :terminal_id         => "0123456789012345",
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

Location message: 
```ruby
{
    :packet_length       => 31,
    :protocol_number     => 18,
    :message_type        => :location_data,
    :information_content =>
        {
            :date_time => '2011-08-29 17:46:16 +0400',
            :gps       =>
                {
                    :quantity_satellites =>
                        {
                            :length_gps => 12, :satellites => 12
                        },
                    :latitude            => 23.111668333333334,
                    :longitude           => 114.409285,
                    :speed               => 0,
                    :course_status       =>
                        {
                            :null_1               => 0,
                            :null_2               => 0,
                            :gps_positioning_type => 0,
                            :is_gps_positioning   => 1,
                            :longitude_bit        => 0,
                            :latitude_bit         => 1,
                            :course               => 143
                        }
                },
            :lbs       =>
                {
                    :mcc     => 460,
                    :mnc     => 0,
                    :lac     => 10365,
                    :cell_id => 8120
                }
        },
    :serial_number       => 3
}
```

The content of 'information_content' depends on 'message_type'
See lib/gt06_server/messages for details  

### Copyright

Copyright (c) 2016 CoolElvis and contributors.

MIT License. See [LICENSE](LICENSE) for details.
