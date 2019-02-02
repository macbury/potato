class User < ApplicationRecord
  enum role: [:developer, :superadmin]
  devise :rememberable, :trackable, :timeoutable, :omniauthable, :lockable, omniauth_providers: [:github]

  has_one_attached :avatar

  has_many :builds, foreign_key: :author_github_id, primary_key: :github_id

  attr_encrypted :token, key: :encryption_key
  after_commit -> { broadcast(:user_created, self) }, on: :create
  after_create :lock_access!
  before_create :generate_api_token

  validates :email, presence: true, uniqueness: true
  validates :token, :name, :github_id, presence: true

  def generate_api_token
    self.api_token = SecureRandom.hex(24)
  end

  private

  def encryption_key
    ENV.fetch('DATA_ENCRYPTION_PASSWORD')
  end
end
