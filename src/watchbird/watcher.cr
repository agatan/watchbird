require "./event"
require "./notifier"
require "./pattern"

module WatchBird
  class Watcher
    INSTANCE = new

    @notifier : Notifier

    def initialize
      @notifier = Notifier.new
      @patterns = [] of Pattern
      @callbacks = [] of Event ->
    end

    def self.watch(&blk)
      ins = new
      begin
        yield ins
      ensure
        ins.close
      end
    end

    def register(pattern : String, &blk : Event ->)
      register(Pattern.new(pattern), blk)
    end

    def register(pattern : String, cb)
      register(Pattern.new(pattern), cb)
    end

    def register(pattern : Pattern, cb)
      @patterns << pattern
      @callbacks << cb
      register_to_notifeir(pattern)
    end

    def run
      loop do
        event = @notifier.wait
        unless event
          return
        end
        @patterns.each_with_index do |pat, i|
          if pat.match?(event.not_nil!.name)
            @callbacks[i].call(event.not_nil!)
          end
        end
      end
    end

    def close
      @notifier.close
    end

    private def register_to_notifeir(pattern)
      @notifier.register(pattern.fixed)
      Dir.foreach(pattern.fixed) do |name|
        unless name == "." || name == ".."
          fullname = pattern.fixed
          if fullname[-1] != File::SEPARATOR
            fullname += File::SEPARATOR
          end
          fullname += name
          if Dir.exists?(fullname)
            @notifier.register(fullname)
          end
        end
      end
    end
  end
end
