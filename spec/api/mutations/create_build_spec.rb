RSpec.describe 'Create build', graphql: true do
  subject { execute_query(mutation_query) }

  let(:mutation_query) do
    %{
      mutation {
        createBuild(projectId: #{project_id}, branch: "master") {
          build {
            status
          }

          errors
        }
      }
    }
  end

  let(:result) { double('Result', success: nil, failure: nil) }

  before do
    allow_any_instance_of(Builds::Create).to receive(:call).and_return(build)
  end

  context 'success' do
    let!(:project) { create(:project, :with_image) }
    let(:project_id) { project.id }
    let(:build) { create(:build, :with_project) }

    it 'returns project' do
      is_expected.to eq({
        createBuild: {
          errors: [],
          build: {
            status: 'pending'
          }
        }
      })
    end
  end

  context 'error' do
    let(:project_id) { -11 }
    let(:build) { FactoryBot.build(:build, project: nil).tap(&:valid?) }

    it 'returns errors' do
      is_expected.to eq({
        createBuild: {
          build: nil,
          errors: ['Project must exist']
        }
      })
    end
  end
end
