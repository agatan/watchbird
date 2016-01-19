require "./event"

ifdef linux
  require "./notifier/inotify"
else
  raise "not implemented yet in darwin"
end
