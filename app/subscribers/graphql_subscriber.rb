# frozen_string_literal: true

class GraphqlSubscriber
  def build_step_output(step, output)
    output = output.dup if output.frozen?
    trigger('stepOutput', { id: step.id }, { output: [output.force_encoding('utf-8')] })
  end

  def trigger_build_changed(build)
    trigger('build', { id: build.id }, build)
    trigger_builds_changed(build)
  end

  def trigger_step_changed(step)
    trigger_build_changed(step.build)
    trigger('step', { id: step.id }, step)
  end

  def trigger_builds_changed(build)
    trigger('build', {}, build)
  end

  alias_method :build_failed, :trigger_build_changed
  alias_method :build_running, :trigger_build_changed
  alias_method :build_done, :trigger_build_changed
  alias_method :build_created, :trigger_build_changed
  alias_method :build_step_done, :trigger_step_changed
  alias_method :build_step_failed, :trigger_step_changed
  alias_method :build_step_started, :trigger_step_changed

  private

  def trigger(*args)
    PotatoSchema.subscriptions.trigger(*args)
  end
end
