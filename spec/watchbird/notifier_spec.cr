require "../spec_helper"

describe WatchBird do
  describe "notifier" do
    it "should notify file create event" do
      with_tmpdir do |dirname|
        ino = WatchBird::Notifier.new
        ino.register(dirname)
        chan = Channel(WatchBird::Event).new
        spawn do
          chan.send(ino.wait)
        end
        `touch #{dirname}/create-file`

        event = chan.receive
        event.should eq WatchBird::Event.new(WatchBird::EventType::Create,
                                             "#{dirname}/create-file",
                                             false)
      end
    end

    it "should notify file modify event" do
      with_tmpdir do |dirname|
        `touch #{dirname}/modify-file`
        ino = WatchBird::Notifier.new
        ino.register(dirname)
        chan = Channel(WatchBird::Event).new
        spawn do
          chan.send(ino.wait)
        end
        `echo test > #{dirname}/modify-file`

        event = chan.receive
        event.should eq WatchBird::Event.new(WatchBird::EventType::Modify,
                                             "#{dirname}/modify-file",
                                             false)
      end
    end

    it "should notify file delete event" do
      with_tmpdir do |dirname|
        `touch #{dirname}/delete-file`
        ino = WatchBird::Notifier.new
        ino.register(dirname)
        chan = Channel(WatchBird::Event).new
        spawn do
          chan.send(ino.wait)
        end
        `rm #{dirname}/delete-file`

        event = chan.receive
        event.should eq WatchBird::Event.new(WatchBird::EventType::Delete,
                                             "#{dirname}/delete-file",
                                             false)
      end
    end

    it "should notify directory create event" do
      with_tmpdir do |dirname|
        ino = WatchBird::Notifier.new
        ino.register(dirname)
        chan = Channel(WatchBird::Event).new
        spawn do
          chan.send(ino.wait)
        end
        `mkdir #{dirname}/create-dir`

        event = chan.receive
        event.should eq WatchBird::Event.new(WatchBird::EventType::Create,
                                             "#{dirname}/create-dir",
                                             true)
      end
    end

    it "should notify file modify directory" do
      with_tmpdir do |dirname|
        `touch #{dirname}/modify-file`
        ino = WatchBird::Notifier.new
        ino.register(dirname)
        chan = Channel(WatchBird::Event).new
        spawn do
          chan.send(ino.wait)
        end
        `echo test > #{dirname}/modify-file`

        event = chan.receive
        event.should eq WatchBird::Event.new(WatchBird::EventType::Modify,
                                             "#{dirname}/modify-file",
                                             false)
      end
    end

  end
end
