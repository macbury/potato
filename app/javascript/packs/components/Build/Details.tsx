import * as React from 'react'
import { compose } from 'recompose'
import { withRouter } from "react-router"
import { withStyles } from '@material-ui/core/styles'

import CardHeader from '@material-ui/core/CardHeader'
import Avatar from '@material-ui/core/Avatar'
import CircularProgress from '@material-ui/core/CircularProgress'

import Wrapper from './Wrapper'
import Summary from './Summary'

const styles = (theme) => ({
  progress: {
    marginTop: '12px',
    marginRight: '12px'
  },
})

function BuildDetails({ build, classes }) {
  const { number, message, author, status, id } = build
  const running = status == 'running'
  return (
    <Wrapper status={status} id={`build_details_${id}`}>
      <CardHeader
        avatar={<Avatar src={author.avatarUrl} />}
        title={`#${number}. ${message}`}
        subheader={<Summary build={build} />}
        action={running && <CircularProgress className={classes.progress}/>}
      />
    </Wrapper>
  )
}

export default compose(
  withRouter,
  withStyles(styles as any)
)(BuildDetails)
