RSpec.describe 'Fetching builds', graphql: true do
  let!(:builds) { create_list(:build, 10, :with_project) }
  subject { execute_query(query_string) }

  let(:query_string) do
    %{
      {
        builds(first: 3) {
          nodes {
            id
            number
            status
            project {
              name
            }
          }
        }
      }
    }
  end

  it 'returns list of paginated builds' do
    is_expected.to match(
      builds: {
        nodes: builds[0..2].map do |build|
          {
            id: build.id,
            number: build.number,
            status: build.status,
            project: {
              name: build.project.name
            }
          }
        end
      }
    )
  end
end
