RSpec.describe 'Create project', graphql: true do
  subject { execute_query(mutation_query) }

  let(:mutation_query) do
    %{
      mutation {
        createProject(repositoryId: 12, name: "example project") {
          project {
            name
            id
            git
          }

          errors
        }
      }
    }
  end

  let(:result) { double('Result', success: nil, failure: nil) }

  before { expect_any_instance_of(CreateProject).to receive(:call).and_yield(result) }

  context 'success' do
    let(:project) { create(:project) }

    before { allow(result).to receive(:success).and_yield(project) }

    it 'returns project' do
      is_expected.to eq({
        createProject: {
          errors: [],
          project: {
            git: project.git,
            id: project.id,
            name: project.name
          }
        }
      })
    end
  end

  context 'error' do
    before { allow(result).to receive(:failure).and_yield('This is bad') }

    it 'returns errors' do
      is_expected.to eq({
        createProject: {
          project: nil,
          errors: ["This is bad"]
        }
      })
    end
  end
end
