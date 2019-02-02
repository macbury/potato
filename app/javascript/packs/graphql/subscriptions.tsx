const onBuildUpdateQuery = require('./queries/subscriptions/onBuildUpdate')
const onStepOutputQuery = require('./queries/subscriptions/onStepOutput')
const onBuildsUpdate = require('./queries/subscriptions/onBuildsUpdate')

export function onBuildUpdate(buildId) {
  return {
    document: onBuildUpdateQuery,
    variables: { buildId },
    updateQuery: ({ currentBuild }, { subscriptionData: { data: { build: { status, steps } } } }) => {
      const updatedBuild = {...currentBuild, status}

      updatedBuild.steps = updatedBuild.steps.map((oldStep) => {
        const newStep = steps.find(({ id }) => oldStep.id === id)
        if (newStep) {
          return {...oldStep, ...newStep}
        } else {
          return {...oldStep}
        }
      })

      return {
        currentBuild: updatedBuild
      }
    }
  }
}

export function onStepOutput(stepId) {
  return {
    document: onStepOutputQuery,
    variables: { stepId },
    updateQuery: ({ currentBuild }, { subscriptionData: { data: { stepOutput: { output } } } } ) => {
      let step = currentBuild.steps.find(({ id }) => stepId === id)

      step.output.push(output)
      return { currentBuild }
    }
  }
}

export function onCurrentBuildsUpdate() {
  return {
    document: onBuildsUpdate,
    updateQuery: ({ currentProject }, { subscriptionData: { data: { build } } } ) => {
      let updatedProject = {...currentProject}
      updatedProject.builds.nodes = updatedProject.builds.nodes.map((oldBuild) => {
        if (oldBuild.id == build.id) {
          return {...oldBuild, ...build}
        } else {
          return {...oldBuild}
        }
      })
      return { currentProject }
    }
  }
}
