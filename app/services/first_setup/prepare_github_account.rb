# frozen_string_literal: true

module FirstSetup
  class PrepareGithubAccount < BaseService
    step :check_if_need_setup
    step :build_redirect_path

    private

    def check_if_need_setup
      User.superadmin.exists? ? Failure() : Success()
    end

    def build_redirect_path
      Success(
        Rails.application.routes.url_helpers.user_github_omniauth_authorize_path(first_setup: true)
      )
    end
  end
end