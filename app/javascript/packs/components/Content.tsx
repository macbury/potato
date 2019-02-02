import * as React from 'react'
import ChangeToolbar from './ChangeToolbar'
import { withStyles } from '@material-ui/core/styles'

const styles = theme => ({
  content: {
    padding: theme.spacing.unit * 2,
    [theme.breakpoints.down('xs')]: {
      padding: '0px'
    }
  },
})

interface IProps {
  classes?: any;
  children?: any;
  title?:string;
  backButtonUrl?:string;
}

function Content({ classes, children, title, backButtonUrl } : IProps) {
  return (
    <div className={classes.content}>
      <ChangeToolbar title={title} backButtonUrl={backButtonUrl} />
      {children}
    </div>
  )
}

export default withStyles(styles as any)(Content)
