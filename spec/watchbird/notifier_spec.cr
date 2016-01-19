require "../spec_helper"

describe WatchBird do
  describe "notifier" do
    ifdef linux
      context "in linux" do
        it "should notify file create event" do
          with_tmpdir do |dirname|
            ino = WatchBird::Inotify.new
            ino.register(dirname)
            chan = Channel(WatchBird::Event).new
            spawn do
              chan.send(ino.wait)
            end
            `touch #{dirname}/create-file`

            event = chan.receive
            event.name.should eq "create-file"
            event.status.should eq WatchBird::EventType::Create
          end
        end

        it "should notify file modify event" do
          with_tmpdir do |dirname|
            `touch #{dirname}/modify-file`
            ino = WatchBird::Inotify.new
            ino.register(dirname)
            chan = Channel(WatchBird::Event).new
            spawn do
              chan.send(ino.wait)
            end
            `echo test > #{dirname}/modify-file`

            event = chan.receive
            event.name.should eq "modify-file"
            event.status.should eq WatchBird::EventType::Modify
          end
        end

        it "should notify file delete event" do
          with_tmpdir do |dirname|
            `touch #{dirname}/delete-file`
            ino = WatchBird::Inotify.new
            ino.register(dirname)
            chan = Channel(WatchBird::Event).new
            spawn do
              chan.send(ino.wait)
            end
            `rm #{dirname}/delete-file`

            event = chan.receive
            event.name.should eq "delete-file"
            event.status.should eq WatchBird::EventType::Delete
          end
        end
      end
    end
  end
end
