# frozen_string_literal: true

class SshKeysSubscriber
  def ssh_key_created(ssh_key)
    Github::Client.add_deploy_key(
      ssh_key.project.repository_id,
      "potato:#{ssh_key.name}",
      ssh_key.public_key
    )
  end
end
