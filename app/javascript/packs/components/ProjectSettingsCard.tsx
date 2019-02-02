import * as React from 'react'
import { compose } from 'recompose'
import { withRouter } from "react-router"
import { withStyles } from '@material-ui/core/styles'

import ProjectDetailsCard from './ProjectDetailsCard'

import Tabs from '@material-ui/core/Tabs';
import Tab from '@material-ui/core/Tab';

function ProjectSettingsCard({ project, history, tab }) {
  const handleChange = (event, value) => {
    history.push(`/projects/${project.id}/edit/${value}`)
  }

  return (
    <ProjectDetailsCard project={project}>
      <Tabs value={tab} indicatorColor="primary" textColor="primary" scrollable scrollButtons="auto" onChange={handleChange}>
        <Tab label="Images" value="images" />
        <Tab label="Pipelines" value="pipelines" />
        <Tab label="Deploys" value="deploys" />
        <Tab label="Environment variables" value="env" />
        <Tab label="SSH Keys" value="ssh" />
      </Tabs>
    </ProjectDetailsCard>
  )
}

export default compose(
  withRouter
)(ProjectSettingsCard)
