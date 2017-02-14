module WatchBird
  class Pattern
    getter fixed : String
    getter rest : Array(String)
    getter pattern : String

    def initialize(pat : String)
      abs_path = File.expand_path(pat)
      @pattern = abs_path
      dirs = abs_path.split(File::SEPARATOR)
      fixed_path = dirs[0]
      if dirs.size > 0
        dirs.shift
        while dirs.size > 0 && Dir.exists?("#{fixed_path}#{File::SEPARATOR}#{dirs[0]}")
          fixed_path += File::SEPARATOR + dirs[0]
          dirs.shift
        end
      end
      @fixed = fixed_path
      if pat[-1] == File::SEPARATOR || @fixed.size < abs_path.size
        @fixed += File::SEPARATOR
      end
      if @fixed.size < abs_path.size
        @rest = abs_path[@fixed.size..-1].split(File::SEPARATOR)
      else
        @rest = [] of String
      end
    end

    def match?(path)
      Dir.glob(pattern).includes?(path)
    end
  end
end
