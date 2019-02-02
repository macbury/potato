module Builds
  class CopySteps
    attr_reader :build, :project

    def initialize(build)
      @build = build
      @project = build.project
    end

    def call
      Build.transaction do
        build.steps.destroy_all

        project.images.each do |image|
          build_steps_from(image, image.build_script)
          build.steps.create(
            owner: image,
            trigger: :after_build,
            command: "git clone #{project.git} ."
          )
          build.steps.create(
            owner: image,
            trigger: :after_build,
            command: "git reset --hard #{build.sha}",
          )
          build_steps_from(image, image.setup_script, trigger: :after_build)
        end

        project.pipelines.each { |pipeline| build_steps_from(pipeline, pipeline.script) }
      end
    end

    private

    def build_steps_from(owner, script, options={})
      commands = split_commands.call(script)
      commands.each do |command|
        build.steps.create({
          command: command,
          owner: owner
        }.merge(options))
      end
    end

    def split_commands
      @split_commands ||= Builds::SplitCommands.new
    end
  end
end
