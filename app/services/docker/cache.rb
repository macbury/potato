module Docker
  class Cache
    def initialize(image)
      @image = image
    end

    def exist?
      host_cache_path.exist?
    end

    def enabled?
      !directories.empty?
    end

    def size
      exists? ? File.size(host_cache_path) : 0
    end

    def purge
      File.unlink(host_cache_path) if exist?
      true
    end

    def restore(runner)
      return unless enabled?
      ensure_directory
      return unless exist?
      runner.put_file(host_cache_path, container_cache_path)
      runner.exec("tar xf #{container_cache_path}")
      runner.exec("rm #{container_cache_path}")
    end

    def store(runner)
      return unless enabled?
      runner.exec("tar cfz #{container_cache_path} #{directories.join(' ')}")
      runner.fetch_file(container_cache_path, host_cache_path)
      runner.exec("rm #{container_cache_path}")
    end

    def with(runner)
      restore(runner)
      yield
      store(runner)
    end

    private

    attr_reader :image

    def directories
      @directories ||= image.caches.map(&:strip).reject(&:empty?)
    end

    def ensure_directory
      FileUtils.mkdir_p(cache_path)
    end

    def cache_path
      Rails.root.join('tmp/cache/images/')
    end

    def container_cache_path
      "/tmp/potato_cache_#{image.id}.tgz"
    end

    def host_cache_path
      cache_path.join("#{image.id}.tgz")
    end
  end
end
