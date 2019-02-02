class WebHook < ApplicationRecord
  belongs_to :project

  before_create :generate_secret
  after_commit -> { broadcast(:web_hook_created, self) }, on: :create

  def valid_sig?(request, signature)
    request.body.rewind
    request_body = request.body.read
    digest = OpenSSL::Digest.new('sha1')
    signature == "sha1=#{OpenSSL::HMAC.hexdigest(digest, secret, request_body)}".downcase
  end

  private

  def generate_secret
    self.secret = SecureRandom.hex
  end
end
