import * as React from 'react'
import classnames from 'classnames'
import { withStyles } from '@material-ui/core/styles'
import Card from '@material-ui/core/Card'

const styles = theme => ({
  card: {
    borderLeft: '6px solid white',
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 2,
    [theme.breakpoints.down('xs')]: {
      borderRadius: '0px'
    }
  },

  failed: {
    borderLeftColor: '#F44336'
  },

  running: {
    borderLeftColor: '#3F51B5'
  },

  done: {
    borderLeftColor: '#4CAF50'
  },

  pending: {
    borderLeftColor: '#9E9E9E'
  }
})

function Wrapper({ status, children, classes, id }) {
  const klasses = classnames(classes.card, {
    [classes.failed]: status === 'failed',
    [classes.running]: status === 'running',
    [classes.done]: status === 'done',
    [classes.pending]: status === 'pending',
  })

  return (
    <Card className={klasses} id={id}>
      {children}
    </Card>
  )
}

export default withStyles(styles as any)(Wrapper)
