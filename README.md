# WatchBird

WatchBird monitors directories and files, then run tasks automatically.

This library is strongly inspired by [guard](https://github.com/guard/guard) and [crake](https://github.com/MakeNowJust/crake).
Thanks ;)

***notice:***  
WatchBird is under development and has few feature yet.
Currently, it provides linux inotify wrapper api only.

# Features

WatchBird is just a library (inspired by [crake](https://github.com/MakeNowJust/crake)).
You can use this library in your application.
it also provides DSL module.
You can use this library with DSL syntax like *guard*.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  watchbird:
    github: agatan/watchbird
```

# Usage
See this code:

```crystal
require "watchbird/dsl"

watch "./**/*.cr" do |ev|
  # ev.status is WatchBird::EventType.
  # can be Modify, Create and Delete.
  puts ev.status
  # ev.name is target fullpath. It is an absolute path.
  puts ev.name
  # ev.dir? returns true when target fullpath is directory
  puts ev.dir?
end
```

and execute `watchbird.cr` like `crystal watchbird.cr`.

This repository contains sample `watchbird.cr` file to run spec automatically.

## Contributing

1. Fork it ( https://github.com/agatan/watchbird/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [agatan](https://github.com/agatan) agatan - creator, maintainer
