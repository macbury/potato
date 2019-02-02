import * as React from 'react'
import Build from './Build'

export default function Builds({ builds, project }) {
  return (
    <React.Fragment>
      {builds.map((build) => <Build build={build} project={project} key={`build_${build.id}`} />)}
    </React.Fragment>
  )
}
