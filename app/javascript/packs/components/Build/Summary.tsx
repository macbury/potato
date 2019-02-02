import * as React from 'react'
import Moment from 'react-moment'
import { withStyles } from '@material-ui/core/styles'

const styles = theme => ({
  bullet: {
    display: 'inline-block',
    margin: '0 8px',
    transform: 'scale(2)',
  }
})

function BuildTime({ status, startedAt, finishedAt }) {
  if (status === 'running') {
    return <Moment durationFromNow date={startedAt} interval={1000} />
  } else if (status === 'pending') {
    return <Moment fromNow>{startedAt}</Moment>
  } else {
    return <Moment duration={startedAt} date={finishedAt} />
  }
}

function Summary({ classes, build: { author, status, branch, sha, startedAt, finishedAt } }) {
  const bullet = <span className={classes.bullet}>•</span>;
  const shortSha = sha.slice(0, 8)
  return (
    <div>
      {author.name}
      {bullet}
      {branch}
      {bullet}
      {shortSha}
      {bullet}
      <BuildTime status={status} startedAt={startedAt} finishedAt={finishedAt} />
      {bullet}
      {status}
    </div>
  )
}

export default withStyles(styles as any)(Summary)
