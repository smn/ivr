$:<< File.dirname(__FILE__)
require 'rubygems'
require 'bundler/setup'
require 'rspec/core/rake_task'
require 'librevox'
require 'digest/md5'

APP_ROOT = File.dirname(__FILE__)
SOUND_ROOT = "#{APP_ROOT}/sounds"

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

# the built in tts stuff is pretty bad and cepstral is too much of a hassle
# this does the trick with Mac OS X's built in `say` tts engine.
def say text, options={}
  voice = options[:voice] || "Alex"
  md5 = Digest::MD5.hexdigest(text)
  file = "#{APP_ROOT}/sounds/cache/#{voice}-#{md5}.wav"
  if not File.exists?(file)
    # say will trip if the output file is not 'wave'
    # but freeswitch will trip if it is. First write it with the wave suffix
    # then rename it to the wav suffix
    `say -v #{voice} -o #{file}e "#{text}" && mv #{file}e #{file}`
    puts "generated file #{file}"
  end
  file
end

class IVR < Librevox::Listener::Outbound
  def session_initiated
    answer
    # application "sleep", "5000"
    # file = "#{APP_ROOT}/sounds/sample.8b.wav"
    # playback file
    # set "tts_engine", "flite"
    # set "tts_voice", "slt"
    # application "speak", "Hello World! Welcome to Voomi, Praykelt's messaging system."
    playback say("Hello World! Welcome to Voomi, Praykelt's messaging system.")
    hangup
    puts "hung up..."
  end
end