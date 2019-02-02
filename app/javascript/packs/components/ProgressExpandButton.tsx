import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import classnames from 'classnames'

import ExpandMoreIcon from '@material-ui/icons/ExpandMore'
import CircularProgress from '@material-ui/core/CircularProgress'

const styles = theme => ({
  container: {
    marginTop: '4px',
    position: 'relative',
  },

  expandedIcon: {
    transform: 'rotate(180deg)',
  },

  progress: {
    position: 'absolute',
    top: '-4px',
    left: '-4px',
    zIndex: 1,
  },
})

interface IProps {
  classes?: any;
  loading: boolean;
  expanded: boolean;
}

function ProgressExpandButton({ classes, loading, expanded } : IProps) {
  return (
    <div className={classes.container}>
      <ExpandMoreIcon className={classnames({ [classes.expandedIcon]: expanded })}/>
      { loading && <CircularProgress size={32} className={classes.progress} /> }
    </div>
  )
}

export default withStyles(styles as any)(ProgressExpandButton)
