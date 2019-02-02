# frozen_string_literal: true

module Docker
  class BaseImageBuilder
    ESSENTIAL_DOCKER_IMAGE_PATH = Rails.root.join('app', 'docker_essential')

    def build
      image = Docker::Image.build_from_dir(ESSENTIAL_DOCKER_IMAGE_PATH.to_s) do |output|
        Docker::ParseOutput.log_output(output)
      end
      image.tag(repo: 'potato-base:latest')
    end
  end
end
