# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  subject { create(:project) }

  it { is_expected.to have_many(:builds) }
  it { is_expected.to have_many(:images) }
  it { is_expected.to have_many(:pipelines) }
  it { is_expected.to have_many(:web_hooks) }

  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:git) }
  it { is_expected.to validate_presence_of(:repository_id) }
end
