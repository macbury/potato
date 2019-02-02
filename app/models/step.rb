# frozen_string_literal: true

class Step < ApplicationRecord
  enum status: %i[pending running done failed cancelled]
  enum trigger: %i[normal after_build]

  belongs_to :owner, polymorphic: true
  belongs_to :build, required: false
  validates :command, presence: true

  scope :for_images, -> { where(owner_type: 'Image') }
  scope :for_pipelines, -> { where(owner_type: 'Pipeline') }

  scope :for_owner, ->(owner) { where(owner: owner) }

  def append_output(output)
    Step.where(id: id).update_all(['output = output || ?::text', output])
    reload
  end
end
