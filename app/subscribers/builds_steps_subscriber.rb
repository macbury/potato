# frozen_string_literal: true

class BuildsStepsSubscriber
  def build_step_started(step)
    step.build.started!
    step.running!
  end

  def build_step_done(step)
    step.done!
  end

  def build_step_output(step, output)
    step.append_output(output)
  end

  def build_step_failed(step)
    step.failed!
  end

  def build_step_cancelled(step)
    step.cancelled!
    build.failed!
  end
end
