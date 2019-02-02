# frozen_string_literal: true

class BuildsSubscriber
  def build_failed(build)
    return unless build.batch_id

    ActiveRecord::Base.transaction do
      build.steps.pending.update_all(status: :cancelled)
      build.steps.running.update_all(status: :cancelled)
      build.update_attributes(batch_id: nil, finished_at: Time.zone.now)
    end

    batch = Sidekiq::Batch.new(build.batch_id)
    batch.invalidate_all
  end

  def build_done(build)
    build.update_attributes(finished_at: Time.zone.now)
  end

  def build_created(build)
    build.update_attributes(started_at: Time.zone.now)
    Builds::CopySteps.new(build).call

    with_batch(build, :sidekiq_build_complete) do
      build.project.images.each do |image|
        Runner::BuildImageJob.perform_async(build.id, image.id)
      end
    end
  end

  def sidekiq_build_complete(status, options)
    build = Build.find(options['build_id'])
    return build.failed! if build_failed?(status, build)

    with_batch(build, :sidekiq_pipelines_complete) do
      build.project.pipelines.each do |pipeline|
        Runner::PipelineJob.perform_async(build.id, pipeline.id)
      end
    end
  end

  def sidekiq_pipelines_complete(status, options)
    build = Build.find(options['build_id'])
    return build.failed! if build_failed?(status, build)

    if false # deploy task present
      with_batch(build, :sidekiq_deploy_complete) do
        # Spawn one deploy job, the deploy job final action is to add another deploy job
        Runner::DeployJob.perform_async(build.id, [])
      end
    else
      sidekiq_deploy_complete(status, options)
    end
  end

  def sidekiq_deploy_complete(status, options)
    build = Build.find(options['build_id'])
    return build.failed! if build_failed?(status, build)

    build.update_attributes(batch_id: nil)
    build.done!
  end

  private

  def build_failed?(status, build)
    status.failures > 0 || build.failed? || build.steps.failed.exists?
  end

  def with_batch(build, callback, &block)
    batch = Sidekiq::Batch.new
    build.update_attributes(batch_id: batch.bid)
    batch.on(:complete, "BuildsSubscriber##{callback}", build_id: build.id)
    batch.jobs(&block)
    batch
  end
end
