# frozen_string_literal: true

require 'tempfile'

module Docker
  class DockerfileBuilder
    attr_reader :image, :commands

    def initialize(image)
      @image = image
      @commands = []
    end

    def run(command)
      @commands << command
    end

    def to_s
      [
        "FROM #{image}",
        commands.map { |command| "RUN #{command}" }
      ].flatten.join("\n")
    end
  end
end
