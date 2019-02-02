module Github
  class Client
    def self.provide(auto_paginate: true)
      user = User.superadmin.first
      raise SuperAdminNotFound unless user
      Octokit::Client.new(access_token: user.token).tap do |client|
        client.auto_paginate = auto_paginate
      end
    end

    def self.method_missing(method_name, *args, &block)
      self.provide.send(method_name, *args, &block)
    end

    def self.respond_to?(*args)
      super(*args) || Octokit::Client.new.respond_to?(*args)
    end
  end
end
