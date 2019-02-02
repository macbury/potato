# frozen_string_literal: true

class SshKey < ApplicationRecord
  enum kind: [:clone, :deploy]
  belongs_to :project

  validates :name, presence: true, uniqueness: { scope: :project_id }

  attr_encrypted :private_key, key: :encryption_key
  before_create :generate_keys

  after_commit -> { broadcast(:ssh_key_created, self) }, on: :create

  private

  def encryption_key
    ENV.fetch('DATA_ENCRYPTION_PASSWORD')
  end

  def generate_keys
    key = SSHKey.generate(comment: "#{name}@potato", bits: 2048)
    self.private_key = key.private_key
    self.public_key = key.ssh_public_key
    self.fingerprint = key.sha1_fingerprint
  end
end
