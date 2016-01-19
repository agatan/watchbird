require "../spec_helper"

describe WatchBird do
  describe "Watcher" do
    context "with relative path pattern" do
      it "runs block when pattern matched file changes" do
        with_tmpdir do |dirname|
          Dir.cd(dirname)
          `touch #{dirname}/test`
          chan = Channel(WatchBird::Event).new
          watcher = WatchBird::Watcher.new
          watcher.register "test" do |ev|
            chan.send(ev)
          end
          spawn { watcher.run }
          File.write("#{dirname}#{File::SEPARATOR}test", "test watcher")
          event = chan.receive
          event.name.should eq "#{dirname}#{File::SEPARATOR}test"
          event.status.should eq WatchBird::EventType::Modify
        end
      end
    end
  end
end
