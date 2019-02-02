# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :ssh_keys, dependent: :destroy
  has_many :web_hooks, dependent: :destroy
  has_many :builds, dependent: :destroy
  has_many :images, -> { order(:id) }, dependent: :destroy
  has_many :pipelines, -> { order(:id) }, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :repository_id, :git, presence: true
end
