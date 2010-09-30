$:<< File.dirname(__FILE__)
require 'rubygems'
require 'bundler/setup'
require 'spec/rake/spectask'
require 'librevox'

task :default => [:spec]

desc "Run all tests"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_opts = ['--format', 'specdoc', '--color']
  t.spec_files = FileList['test/spec/*.rb']
end

namespace :ivr do
  desc "Start the IVR experiment"
  task :start do |t|
    EM.run do
      trap("INT") { EM.stop }
      trap("TERM") { EM.stop }
      Librevox.start IVR
    end
  end
end

class IVR < Librevox::Listener::Outbound
  def session_initiated
    answer
    wave_file = "/Users/sdehaan/Documents/Repositories/vumi_ivr/sample.wav"
    digit = play_and_get_digits wave_file, wave_file
    puts "User pressed #{digit}"
    hangup
  end
end


