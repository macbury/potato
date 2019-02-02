RSpec.describe 'Fetching project', graphql: true do
  let!(:project) { create(:project, :with_image, :with_builds) }
  subject { execute_query(query_string) }

  let(:query_string) do
    %{
      {
        project(id: #{project.id}) {
          name
          id
          git

          builds(order: Oldest) {
            nodes {
              status
              id
              number
            }
          }
        }
      }
    }
  end

  it 'fetch project and return list of builds' do
    is_expected.to match(
      project: {
        name: project.name,
        id: project.id,
        git: project.git,
        builds: {
          nodes: project.builds.order('created_at ASC').map do |build|
            {
              status: build.status,
              id: build.id,
              number: build.number
            }
          end
        }
      }
    )
  end
end
