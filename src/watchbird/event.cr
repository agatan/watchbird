module WatchBird
  @[Flags]
  enum EventType
    Modify
    Delete
    Create
  end

  class Event
    getter name : String
    getter status : EventType

    @is_dir : Bool

    def initialize(@status, @name, @is_dir); end

    def dir?
      @is_dir
    end

    def ==(other)
      name == other.name && status == other.status && dir? == other.dir?
    end
  end
end
