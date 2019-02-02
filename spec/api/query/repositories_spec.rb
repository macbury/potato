RSpec.describe 'Fetching repositories', graphql: true do
  subject { execute_query(query_string) }

  let(:query_string) do
    %{
      {
        repositories {
          name
          cloneUrl
          avatarUrl
          owner
        }
      }
    }
  end

  let(:github_response) do
    [
      {
        name: 'alonetone',
        ssh_url: 'git@github.com:macbury/alonetone.git',
        owner: {
          avatar_url: 'https://avatars0.githubusercontent.com/u/110908?v=4',
          login: 'macbury'
        }
      }, {
        name: 'amistad',
        ssh_url: 'git@github.com:macbury/amistad.git',
        owner: {
          avatar_url: 'https://avatars0.githubusercontent.com/u/110908?v=4',
          login: 'macbury'
        }
      }
    ]
  end

  before do
    expect(Github::FetchRepositories).to receive(:call).and_return(double('Success', success: github_response))
  end

  it 'returns list of all repositories from github' do
    is_expected.to match(
      repositories: [
        {
          name: "alonetone",
          cloneUrl: "git@github.com:macbury/alonetone.git",
          avatarUrl: "https://avatars0.githubusercontent.com/u/110908?v=4",
          owner: "macbury"
        },
        {
          name: "amistad",
          cloneUrl: "git@github.com:macbury/amistad.git",
          avatarUrl: "https://avatars0.githubusercontent.com/u/110908?v=4",
          owner: "macbury"
        },
      ]
    )
  end
end
