class CreateProject < BaseService
  attr_reader :repository_id, :name

  around :transaction

  try :octokit, catch: Github::SuperAdminNotFound 
  try :repository, catch: [Octokit::NotFound, Octokit::InvalidRepository]
  try :create_project, catch: ActiveRecord::RecordInvalid
  tee :bootstrap_project
  tee :create_deploy_keys
  tee :add_webhook

  def initialize(repository_id:, name:)
    super
    @repository_id = repository_id
    @name = name
  end

  private

  def create_project(repository)
    Project.create!(name: name, repository_id: repository_id, git: repository.ssh_url)
  end

  def bootstrap_project(project)
    image = project.images.create(
      name: 'main',
      build_script: 'echo "Prepare your services here"',
      setup_script: 'echo "Your code is already cloned, install all your dependencies here, run migrations, etc."',
      caches: [
        'vendor/gems',
        'node_modules/'
      ]
    )
    project.pipelines.create(
      name: 'test',
      image: image,
      script: 'echo "Run your tests here"'
    )
  end

  def create_deploy_keys(project)
    project.ssh_keys.create(name: 'clone')
  end

  def add_webhook(project)
    project.web_hooks.create
  end

  def octokit
    @octokit ||= Github::Client.provide
  end

  def repository
    @repository ||= octokit.repository(repository_id)
  end

  def transaction(input, &block)
    result = nil
    Project.transaction do
      result = block.(Success(input))
      raise ActiveRecord::Rollback if result.failure?
      result
    end
    return result
  end
end
