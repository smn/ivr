$:<< File.dirname(__FILE__)
require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'librevox'
require 'vumi/ivr'

APP_ROOT = File.dirname(__FILE__)
SOUND_ROOT = "#{APP_ROOT}/sounds"

task :default => [:spec]

desc "Run all tests"
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['--format', 'specdoc', '--color']
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :ivr do
  desc "Start the IVR Transport"
  task :start do |t|
    config = YAML.load_file(ENV['config'] || 'config.yaml')
    fs_config = config['freeswitch']
    EM.run do
      trap("INT") { EM.stop }
      trap("TERM") { EM.stop }
      Librevox.start Vumi::IVR, :host => fs_config["host"], :port => fs_config["port"], :auth => fs_config["auth"]
    end
  end
end

