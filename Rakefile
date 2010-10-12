$:<< File.dirname(__FILE__)
require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'librevox'

APP_ROOT = File.dirname(__FILE__)

task :default => [:spec]

desc "Run all tests"
RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['--format', 'specdoc', '--color']
  t.pattern = 'spec/**/*_spec.rb'
end

namespace :ivr do
  desc "Start the IVR experiment"
  task :start do |t|
    Librevox.start IVR
  end
end

class IVR < Librevox::Listener::Outbound
  def session_initiated
    answer
    sleep 5000
    file = "#{APP_ROOT}/sounds/sample.8b.wav"
    playback file
    hangup
  end
end