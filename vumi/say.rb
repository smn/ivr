module Vumi
  module Say
    # the built in TTS stuff is pretty bad and Cepstral is too much of a hassle
    # this does the trick with Mac OS X's built in `say` command line TTS app.
    def rehearse text, options={}
      voice = options[:voice] || "Alex"
      sound_root = options[:directory] || SOUND_ROOT
      md5 = Digest::MD5.hexdigest(text)
      file = "#{sound_root}/cache/#{voice}-#{md5}.wav"
      if not File.exists?(file)
        # say will trip if the output file is not 'wave'
        # but freeswitch will trip if it is. First write it with the wave suffix
        # then rename it to the wav suffix
        `say -v #{voice} -o #{file}e --data-format=LEI8@8000 "#{text}" && mv #{file}e #{file}`
      end
      file
    end
    
    def say *args
      playback rehearse(*args)
    end
    
    def rehearse_menu text, items=[], options={}
      msg = items.inject("#{text}\n") do |text, item|
        text << "#{items.find_index(item) + 1}. #{item}. \n"
      end
      rehearse msg, options
    end
    
    def say_menu *args
      playback rehearse_menu(*args)
    end
    
  end
end