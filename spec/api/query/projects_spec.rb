RSpec.describe 'Fetching projects', graphql: true do
  let!(:projects) { create_list(:project, 10) }
  subject { execute_query(query_string) }

  let(:query_string) do
    %{
      {
        projects(first: 3) {
          nodes {
            name
            id
            git
          }
        }
      }
    }
  end

  it 'returns list of paginated projects' do
    is_expected.to match(
      projects: {
        nodes: projects[0..2].map do |project|
          {
            name: project.name,
            id: project.id,
            git: project.git
          }
        end
      }
    )
  end
end
