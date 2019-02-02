# frozen_string_literal: true

class Build < ApplicationRecord
  enum status: %i[pending running done failed]

  belongs_to :user, inverse_of: :builds, foreign_key: :author_github_id, primary_key: :github_id, required: false
  belongs_to :project
  has_many :images, through: :project
  has_many :pipelines, through: :project
  has_many :ssh_keys, through: :project
  has_many :steps, -> { order(:id) }, inverse_of: :build, dependent: :destroy

  before_create :set_next_number
  after_commit :publish_created, on: :create
  validates_with BuildValidator
  validates :author_name, :author_github_id, :message, :branch, :sha, presence: true

  def duration
    from = self.started_at || Time.zone.now
    to = self.finished_at || Time.zone.now
    to - from
  end

  def temp_path
    Rails.root.join('tmp', 'builds', id.to_s)
  end

  def repository_path
    temp_path.join('scm/')
  end

  def failed!
    super
    broadcast(:build_failed, self)
  end

  def done!
    super
    broadcast(:build_done, self)
  end

  def running!
    super
    broadcast(:build_running, self)
  end

  def started!
    running! if pending?
  end

  private

  def set_next_number
    self.number = (project.builds.maximum(:number) || 0) + 1
  end

  def publish_created
    broadcast(:build_created, self)
  end
end
