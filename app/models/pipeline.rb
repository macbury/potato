# frozen_string_literal: true

class Pipeline < ApplicationRecord
  belongs_to :project
  belongs_to :image

  has_many :steps, as: :owner, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :project_id }
end
