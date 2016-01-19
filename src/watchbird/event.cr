module WatchBird
  @[Flags]
  enum EventType
    Modify
    Delete
    Create
  end

  class Event
    @name :: String
    @status :: EventType
    @is_dir :: Bool

    getter :name, :status

    def initialize(@status, @name, @is_dir); end

    def dir?; @is_dir; end

    def ==(other)
      name == other.name && status == other.status && dir? == other.dir?
    end
  end
end
