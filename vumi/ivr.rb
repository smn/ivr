require 'vumi/say'
require 'vumi/amqp'
require 'json'

SESSION_NEW = 1
SESSION_EXISTING = 2
SESSION_END = 3

module Vumi
  class IVR < Librevox::Listener::Outbound
    include Vumi::Say
    include Vumi::Amqp
    
    event :channel_hangup do
      done
    end
    
    def config
      @config ||= YAML.load_file(ENV['config'] || 'config.yaml')
    end
    
    def session_initiated
      connect_amqp config['amqp'] do |amqp|
        
        # announce the new session
        publish({
          :from => session[:channel_caller_id_number],
          :to => session[:channel_username],
          :type => SESSION_NEW
        }, :routing_key => @amqp_config['inbound_key'])
        
        outbound do |header, body|
          # parse incoming data
          data = JSON.load(body)
          
          # only do this if we're not ending a session
          if data["type"] == SESSION_EXISTING
            
            # rehearse the question, this does the TTS, saves a WAVE file and 
            # returns the file path
            question = rehearse data["message"]
            error = rehearse "Sorry, something went wrong, please try again."
            
            # Fibers are Ruby 1.9's continuations, Ruby is complaining about
            # Fibers not being allowed to yield from the root Fiber. This
            # `Fiber { ... }.resume` hack does the trick
            Fiber.new {
              # play the question to the user, repeat if invalid input
              # is given
              digit = play_and_get_digits(question, error, {
                :min => 1,
                :max => 1,
                :timeout => 2000,
                :regex => '\d+'
              })
              
              # publish the answer received to the queue
              publish({
                :from => session[:channel_caller_id_number],
                :to => session[:channel_username],
                :type => SESSION_EXISTING,
                :message => digit.to_i
              }, :routing_key => @amqp_config['inbound_key'])
            }.resume
          elsif data["type"] == SESSION_END
            # sign-off & hang up
            Fiber.new { 
              say data["message"] 
              hangup
            }.resume
          end
        end
        
        answer
        application "sleep", "2000"
      end
    end
  end
end