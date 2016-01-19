require "./event"

module WatchBird
  abstract class Notifier
    abstract def register(path)
    abstract def unregister(path)
    abstract def wait()
    abstract def destroy()
  end
end

ifdef linux
  require "./notifier/inotify"
end
