# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :project
  has_many :steps, as: :owner, dependent: :destroy

  validates :base, presence: true
  validates :name, presence: true, uniqueness: { scope: :project_id }

  def docker_name
    "#{project.name}-#{name}".parameterize
  end

  def to_dockerfile
    Docker::DockerfileBuilder.new(base).tap do |df|
      Builds::SplitCommands.new.call(build_script).each do |command|
        df.run(command)
      end
    end
  end
end
