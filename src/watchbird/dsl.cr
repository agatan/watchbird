require "./watcher"

module WatchBird::DSL
  def watch(path, &blk : Event -> Void)
    Watcher::INSTANCE.register(path, blk)
  end
end

include WatchBird::DSL

at_exit do
  WatchBird::Watcher::INSTANCE.run
end
