import * as React from 'react'
import _ from 'lodash'
import { withStyles } from '@material-ui/core/styles'
import Thread from './Thread'

const styles = theme => ({
  container: {
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 4
  }
})

function Threads({ steps, classes }) {
  const groupedSteps = _.groupBy(steps, 'group')
  return (
    <div className={classes.container}>
      {_.map(groupedSteps, (subSteps, group) => <Thread key={group} steps={subSteps} />)}
    </div>
  )
}

export default withStyles(styles as any)(Threads)
