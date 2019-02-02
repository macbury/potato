module Builds
  class SplitCommands
    def call(text)
      text.split("\n").map do |line|
        line.gsub!(/#.+\z/i, '')
        line.strip
      end.reject(&:empty?)
    end
  end
end