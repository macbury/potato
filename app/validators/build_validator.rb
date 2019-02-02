# frozen_string_literal: true

class BuildValidator < ActiveModel::Validator
  def validate(build)
    build.errors.add(:base, 'Images are required') if build.project&.images&.empty?
    build.errors.add(:base, 'Pipelines are required') if build.project&.pipelines&.empty?
  end
end
