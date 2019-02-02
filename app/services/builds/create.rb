module Builds
  class Create
    attr_reader :project, :branch, :sha

    def initialize(project:, branch: 'master', sha: nil)
      @project = project
      @branch = branch
      @sha = sha
    end

    def call
      Build.create(
        project: project,
        sha: commit[:sha], 
        branch: branch, 
        message: commit[:commit][:message], 
        author_name: author_name,
        author_github_id: author_id
      )
    rescue Octokit::InvalidRepository, Octokit::NotFound
      return build_with_errors('Could not find branch or commit sha')
    end

    private

    def build_with_errors(error)
      Build.new.tap do |build|
        build.errors.add(:base, error)
      end
    end

    def author_name
      commit[:author] ? commit[:author][:login] : commit[:commit][:author][:name]
    end

    def author_id
      commit[:author] ? commit[:author][:id] : commit[:commit][:author][:email]
    end

    def commit
      @commit ||= Github::Client.provide(auto_paginate: false).commits(
        project.repository_id,
        sha || branch
      ).first
    end
  end
end
