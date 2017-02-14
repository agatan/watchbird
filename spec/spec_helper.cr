require "spec"
require "../src/watchbird"

def with_tmpdir
  dirname = `mktemp -d`.chomp
  begin
    yield dirname
  ensure
    `rm -r #{dirname}`
  end
end
