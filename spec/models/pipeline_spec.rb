# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline, type: :model do
  it { is_expected.to belong_to(:project) }
  it { is_expected.to belong_to(:image) }
  it { is_expected.to have_many(:steps) }

  it { is_expected.to validate_uniqueness_of(:name).scoped_to(:project_id) }
end
