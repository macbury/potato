# frozen_string_literal: true

module Session
  class CreateGithub < BaseService
    step :find_or_create_user
    step :prepare_first_boot
    step :check_if_can_access

    private

    def find_or_create_user(params:, omniauth:)
      user       = User.find_or_initialize_by(github_id: omniauth['uid'])
      user.token ||= omniauth['credentials']['token']
      user.email = omniauth['info']['email']
      user.name  = omniauth['info']['nickname']
      user.avatar.attach(io: open(omniauth['info']['image']), filename: 'avatar')

      user.save ? Success(params: params, user: user) : Failure(user.errors.full_messages.join(','))
    end

    def prepare_first_boot(params:, user:)
      if params['first_setup']
        return Failure('Setup already completed') if User.superadmin.exists?
        User.transaction do
          user.superadmin!
          user.unlock_access!
        end
      end
      Success(user)
    end

    def check_if_can_access(user)
      Success(user)
    end
  end
end
