# frozen_string_literal: true

module Docker
  class BuildImage
    attr_reader :name, :dockerfile, :image, :errors

    def initialize(name, dockerfile)
      @name = name
      @dockerfile = dockerfile
      @errors = []
    end

    def build(&block)
      @errors = []
      write_dockerfile
      @image = Docker::Image.build_from_dir(temp_dir.to_s) do |output|
        if block
          ParseOutput.parse_output(output) do |item|
            if item['stream']
              yield(item['stream'])
            elsif item['errorDetail']
              message = item['errorDetail']['message']
              @errors << message
            end
          end
        end
      end

      image.tag(repo: name)
      image
    ensure
      cleanup
    end

    def temp_dir
      Rails.root.join('tmp', 'build', 'docker', name).tap do |path|
        FileUtils.mkdir_p(path)
      end
    end

    private

    def write_dockerfile
      File.open(temp_dir.join('Dockerfile'), 'w') do |f|
        f.write(dockerfile.to_s)
      end
    end

    def cleanup
      FileUtils.rm_rf(temp_dir) if temp_dir.exist?
    end
  end
end
