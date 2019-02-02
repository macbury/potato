import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import classNames from 'classnames'
import Paper from '@material-ui/core/Paper'

const styles = theme => ({
  responsivePaper: {
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 2,
    padding: '10px 0px',
    [theme.breakpoints.down('xs')]: {
      borderRadius: '0px',
      padding: '0px',
      margin: '0px'
    }
  },
  form: {
    padding: theme.spacing.unit * 2,
  }
})

interface IProps {
  classes?: any;
  children: React.ReactNode;
  form?:boolean;
}

function ResponsivePaper({ classes, children, form } : IProps) {
  const klasses = classNames(
    classes.responsivePaper, {
      [classes.form]: form
    }
  )
  return <Paper className={klasses}>{children}</Paper>
}

export default withStyles(styles as any)(ResponsivePaper)