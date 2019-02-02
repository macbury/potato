module FirstSetup
  class PrepareOmniauthStrategy < BaseService
    step :check_if_first_setup
    step :build_redirect_path

    private

    def check_if_first_setup(params:, env:)
      if params[:first_setup]
        Success(env)
      else
        Failure()
      end
    end

    def build_redirect_path(env)
      env['omniauth.strategy'].options['scope'] = [
        'user:email',
        'repo',
        'read:org',
        'write:public_key',
        'write:repo_hook'
      ].join(',')
      Success()
    end
  end
end
