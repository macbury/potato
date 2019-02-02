# frozen_string_literal: true

module ApplicationHelper
  def render_application_root
    props = {
      flash: flash.reject { |_, m| m == true }.map { |t, m| { id: SecureRandom.hex(10), type: t, message: m, __typename: 'FlashMessage' } },
      signedIn: user_signed_in?
    }
    content_tag :div, '', id: 'application-root', data: { props: props.to_json }
  end
end
