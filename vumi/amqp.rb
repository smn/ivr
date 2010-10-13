require 'amqp'
require 'mq'
require 'json'

module Vumi
  module Amqp
    def connect_amqp(config)
      @amqp_config = config
      connection = AMQP.connect(:user => config['username'],
                                :pass => config['password'],
                                :host => config['host'], 
                                :port => config['port'], 
                                :vhost => config['vhost'])
      yield connection if block_given?
    end

    def publish data, options = {}
      exchange.publish data.to_json, options
    end

    def exchange
      @exchange ||= MQ.topic(@amqp_config['exchange'])
    end

    def outbound &block
      @outbound ||= queue(exchange, @amqp_config['outbound_queue'], @amqp_config['outbound_key'])
      @outbound.subscribe &block
    end

    def queue(exchange, name, routing_key)
      MQ.queue(name).bind(exchange, :key=> routing_key)
    end
  end
end