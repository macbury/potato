class WebhookController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :load_webhook!

  def github
    Rails.logger.info "Event name: #{event_name}"
    handler&.call(project: @webhook.project, ref: ref_param, sha: head_commit_param) do |resp|
      resp.success do |build|
        Rails.logger.debug "Created build: #{build.id}"
      end

      resp.failure do |errors|
        Rails.logger.error "Could not save build: #{errors.inspect}"
      end
    end
    render json: { status: 'nice' }
  end

  private

  def handler
    if event_name == 'push'
      Github::Webhooks::PushEvent.new
    else
      nil
    end
  end

  def load_webhook!
    @webhook = WebHook.find(params.require(:id))
    render status: 403, json: { error: 'invalid signature' } unless @webhook.valid_sig?(request, signature)
  end

  def head_commit_param
    params.require(:head_commit).require(:id)
  end

  def ref_param
    params.require(:ref)
  end

  def event_name
    request.env['HTTP_X_GITHUB_EVENT']
  end

  def signature
    request.env['HTTP_X_HUB_SIGNATURE']
  end
end
