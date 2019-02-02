module Github
  class FetchRepositories < BaseService
    step :load_superadmin
    step :fetch_organizations
    step :fetch_org_repositories
    step :fetch_user_repos

    private

    def load_superadmin
      Success(client: Github::Client.provide)
    end

    def fetch_organizations(client:)
      Success(
        organizations: client.organizations.map(&:login),
        client: client
      )
    end

    def fetch_org_repositories(organizations:, client:)
      repos = organizations.flat_map { |name| client.organization_repositories(name, type: 'owner') }
      Success(repos: repos, client: client)
    end

    def fetch_user_repos(repos:, client:)
      repos += client.repos({}, query: { type: 'owner' })
      Success(repos.map(&:to_h))
    end
  end
end
