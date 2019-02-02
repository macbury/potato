# frozen_string_literal: true

module Docker
  class ContainerRunner
    attr_reader :image_name, :env, :logger
    CLEANUP_REGEXP = /\A\/tmp\/potato_\d+\.sh: line \d+:/i.freeze
    EXEC_TIMEOUT = 2 * 60 * 60

    def initialize(image_name, logger: nil)
      @image_name = image_name
      @logger = logger
      @env = {}
    end

    def fetch_file(container_path, host_path)
      host.run("docker cp #{id}:#{container_path} #{host_path}")
    end

    def put_file(host_path, container_path)
      host.run("docker cp #{host_path} #{id}:#{container_path}")
    end

    def id
      container.id[0..11]
    end

    def boot(env: {}, container_name: nil, keys: {}, &block)
      @env = env
      container.start
      prepare_ssh(keys)
      block&.call
    ensure
      container.kill
      container.delete
      @container = nil
    end

    def exec(command, tty: true, &block)
      logger&.debug "Running: #{command}"
      _stdout, _stderr, code = container.exec(['/bin/bash', '-l', '-c', command], tty: tty) do |chunk, _stream|
        if chunk
          logger&.debug chunk
          yield(chunk) if block
        end
      end
      code.zero?
    end

    def commit(name)
      repo, tag = name.split(':')
      image = container.commit
      image.tag(repo: repo, tag: tag)
      image
    end

    def recipe
      {
        'Image' => image_name,
        'Tty' => true,
        'OpenStdin' => true,
        'StdinOnce' => false,
        'Privileged' => true,
        'Env' => env.map { |k, v| "#{k}=#{v}" }
      }
    end

    def container
      @container ||= Docker::Container.create(recipe)
    end

    private

    def host
      @host ||= TTY::Command.new
    end

    def boot_ssh_agent
      4.times do
        return if exec('ssh-agent -a ${SSH_AUTH_SOCK}', tty: false)
        sleep 1
      end
      raise 'Could not boot the ssh agent...'
    end

    def prepare_ssh(keys)
      boot_ssh_agent
      keys.each do |name, content|
        key_path = "/root/.ssh/key_#{name}"
        container.store_file(key_path, content)
        exec("chmod 0600 #{key_path}")
        exec("ssh-add #{key_path}")
      end
    end
  end
end

