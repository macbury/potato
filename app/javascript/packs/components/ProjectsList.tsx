import * as React from 'react'
import { withRouter } from "react-router"

import Moment from 'react-moment'
import List from '@material-ui/core/List'
import ListItem from '@material-ui/core/ListItem'
import ListItemIcon from '@material-ui/core/ListItemIcon'
import ListItemText from '@material-ui/core/ListItemText'
import FolderIcon from '@material-ui/icons/Folder'
import ResponsivePaper from './ResponsivePaper'
import ErrorContent from './ErrorContent'

function ProjectDetailsDescription({ build }) {
  if (!build || !build.startedAt) {
    return <span>Waiting for first build</span>
  }

  return (
    <Moment fromNow>
      {build.startedAt}
    </Moment>
  )
}

const Project = withRouter(({ project: { name, id, builds: { nodes } }, history }) => {
  const build = nodes[0]
  return (
    <ListItem button onClick={() => history.push(`/projects/${id}`)}>
      <ListItemIcon>
        <FolderIcon />
      </ListItemIcon>
      <ListItemText primary={name}
                    secondary={<ProjectDetailsDescription build={build} />} />
    </ListItem>
  )
})

export default function ProjectsList({ projects, loading, children }) {
  if (!loading && projects.length == 0) {
    return <ErrorContent message={I18n.t('projects.index.empty.header')} />
  }
  return (
    <ResponsivePaper>
      <List component="nav">
        {projects.map((project, index) => <Project project={project} key={`project_${index}`} />)}
      </List>
      {children}
    </ResponsivePaper>
  )
}
