import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import Typography from '@material-ui/core/Typography'
import InfoIcon from '@material-ui/icons/Info'

function ErrorContent({ message, classes }) {
  return (
    <div className={classes.content}>
      <InfoIcon className={classes.icon} />
      <Typography variant="title" className={classes.header}>{message}</Typography>
    </div>
  )
}

const styles = theme => ({
  content: {
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 4
  },
  header: {
    textAlign: 'center',
    opacity: '0.54'
  },
  icon: {
    display: 'block',
    margin: '40px auto 20px auto',
    width: '64px',
    height: '64px',
    opacity: '0.54'
  }
})

export default withStyles(styles as any)(ErrorContent)
