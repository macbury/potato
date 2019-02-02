import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import Content from './Content'

const styles = theme => ({
  inner: {
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 4
  },
})

function CenteredContent({ classes, children, ...rest }) {
  return <Content {...rest}><div className={classes.inner}>{children}</div></Content>
}

export default withStyles(styles as any)(CenteredContent)
