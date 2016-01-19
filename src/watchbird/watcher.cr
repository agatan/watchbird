require "./event"
require "./notifier"

module WatchBird
  class Watcher

    INSTANCE = new

    @notifier :: Notifier

    def initialize()
      @notifier = Notifier.new
      @targets = {} of String => (Event -> Void)
    end

    def register(pattern, &blk : Event -> Void)
      path = File.expand_path(pattern)
      @targets[path] = blk
      register_to_notifeir(path)
    end

    def run()
      loop do
        event = @notifier.wait()
        @targets[event.name]?.try &.call(event)
      end
    end

    private def register_to_notifeir(path)
      # first, not support glob pattern, but path.
      if Dir.exists?(File.dirname(path))
        @notifier.register(File.dirname(path))
      end
    end

  end
end
