class SessionController < Devise::OmniauthCallbacksController
  include Devise::Controllers::SignInOut

  def new;end

  def first_setup
    FirstSetup::PrepareGithubAccount.call do |r|
      r.success { |url| redirect_to url }
      r.failure { redirect_to root_path, error: 'Setup already complete' }
    end
  end

  def setup
    FirstSetup::PrepareOmniauthStrategy.call(
      params: params,
      env: request.env
    )
    render status: 404, layout: false
  end

  def github
    Session::CreateGithub.call(params: request.env['omniauth.params'], omniauth: request.env['omniauth.auth']) do |resp|
      resp.success do |user|
        sign_in user, :event => :authentication
        set_flash_message(:notice, :success, kind: 'Github' )
        redirect_to root_path
      end

      resp.failure { |message| redirect_to failure_session_path(error_description: message) }
    end
  end

  def destroy
    sign_out(:user)
    set_flash_message! :notice, :signed_out
    redirect_to root_path
  end

  def failure
    @error = params[:error_description]
  end
end
