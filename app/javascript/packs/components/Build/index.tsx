import * as React from 'react'
import classnames from 'classnames'
import { compose } from 'recompose'
import { withRouter } from "react-router"
import { withStyles } from '@material-ui/core/styles'

import Avatar from '@material-ui/core/Avatar'
import CardActionArea from '@material-ui/core/CardActionArea'
import CardHeader from '@material-ui/core/CardHeader'
import CircularProgress from '@material-ui/core/CircularProgress'
import Badge from '@material-ui/core/Badge'
import Wrapper from './Wrapper'
import Summary from './Summary'

const styles = theme => ({
  progress: {
    marginTop: '12px',
    marginRight: '12px'
  },
})

function Build({ build, project, history, classes, width }) {
  const { id, message, author, status, number } = build
  const running = status === 'running'

  return (
    <Wrapper status={status} id={`build_${id}`}>
      <CardActionArea onClick={() => history.push(`/projects/${project.id}/builds/${id}`)}>
        <CardHeader
          avatar={<Avatar src={author.avatarUrl} />}
          title={`#${number}. ${message}`}
          subheader={<Summary build={build} />}
          action={running && <CircularProgress className={classes.progress}/>}
        />
      </CardActionArea>
    </Wrapper>
  )
}

export default compose(
  withRouter,
  withStyles(styles as any)
)(Build)
