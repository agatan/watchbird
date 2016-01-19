require "../spec_helper"
require "../../src/watchbird/pattern"

describe WatchBird::Pattern do
  it "should separate fixed path and glob pattern" do
    pat = WatchBird::Pattern.new("/tmp/*")
    pat.fixed.should eq "/tmp/"
    pat.pattern.should eq "/tmp/*"
  end

  it "should not separate non-glob pattern" do
    pat = WatchBird::Pattern.new("/tmp/")
    pat.fixed.should eq "/tmp/"
  end

  it "should expand pattern" do
    Dir.cd "/tmp"
    pat = WatchBird::Pattern.new("file")
    pat.fixed.should eq "/tmp/"
  end

  it "should expand pattern and separate glob" do
    Dir.cd "/tmp"
    pat = WatchBird::Pattern.new("src/*.cr")
    pat.fixed.should eq "/tmp/"
    pat.pattern.should eq "/tmp/src/*.cr"
  end

  it "should regard non-exist directory as glob pattern" do
    pat = WatchBird::Pattern.new("/tmp/hogehogefugafuga/*/test")
    unless Dir.exists?("/tmp/hogehogefugafuga/")
      pat.fixed.should eq "/tmp/"
      pat.pattern.should eq "/tmp/hogehogefugafuga/*/test"
    end
  end

  describe "match?" do
    it "should return true if path matches pattern" do
      with_tmpdir do |dirname|
        pat = WatchBird::Pattern.new("#{dirname}#{File::SEPARATOR}**/*.txt")
        Dir.mkdir("#{dirname}#{File::SEPARATOR}test")
        filename = "#{dirname}#{File::SEPARATOR}test#{File::SEPARATOR}test.txt"
        File.write(filename, "test")
        pat.match?(filename).should eq true
      end
    end

    it "should return false if path doesn't match pattern" do
      pat = WatchBird::Pattern.new("/tmp/test/**/*.txt")
      pat.match?("/hoge").should eq false
      pat.match?("/tmp/false").should eq false
    end
  end
end
