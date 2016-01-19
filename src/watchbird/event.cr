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

    getter :name, :status

    def initialize(@status, @name); end
  end
end
