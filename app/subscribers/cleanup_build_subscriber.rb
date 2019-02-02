# frozen_string_literal: true

class CleanupBuildSubscriber
  def build_done(build)
    build_cleanup(build)
  end

  def build_failed(build)
    build_cleanup(build)
  end

  private

  def build_cleanup(build)
    build.images.each { |image| Runner::CleanupImageJob.perform_async(build.id, image.id) }

    Rails.logger.debug("Triggered cleanup for: #{build.id}")
    return unless build.temp_path.exist?

    FileUtils.remove_dir(build.temp_path)
    Rails.logger.debug("Removed temp directory: #{build.temp_path}")
  end
end
