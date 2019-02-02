# frozen_string_literal: true

class WebHooksSubscriber
  def web_hook_created(web_hook)
    Github::Client.provide.create_hook(web_hook.project.repository_id, 'web', {
      url: Rails.application.routes.url_helpers.webhook_url(web_hook),
      content_type: 'json',
      secret: web_hook.secret
    },{
      events: ['push', 'pull_request', 'pull_request_review_comment'],
      active: true
    })
  end
end
