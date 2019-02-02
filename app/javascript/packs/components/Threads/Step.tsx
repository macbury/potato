import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import classnames from 'classnames'

import Typography from '@material-ui/core/Typography'
import IconButton from '@material-ui/core/IconButton'
import ButtonBase from '@material-ui/core/ButtonBase'
import Paper from '@material-ui/core/Paper'
import ConsoleOutput from '../ConsoleOutput'
import ProgressExpandButton from '../ProgressExpandButton'

const styles = theme => ({
  root: {

  },

  expanded: {
    marginBottom: theme.spacing.unit * 2,
    marginTop: theme.spacing.unit * 2
  },

  summary: {
    width: '100%',
    borderLeft: '6px solid white',
    padding: '0 18px 0 24px',
    minHeight: 8 * 6,
    display: 'flex',
    '&:hover:not($disabled)': {
      cursor: 'pointer',
    }
  },

  summaryText: {
    margin: '12px 0',
    display: 'flex',
    flexGrow: 1,
  },

  failed: {
    borderLeftColor: '#F44336'
  },

  cancelled: {
    borderLeftColor: '#9E9E9E'
  },

  running: {
    borderLeftColor: '#3F51B5'
  },

  done: {
    borderLeftColor: '#4CAF50'
  },

  pending: {
    borderLeftColor: '#9E9E9E'
  },
})

interface IState {
  expanded: boolean;
}

class Step extends React.Component<any, IState> {
  private outputEl : HTMLPreElement
  constructor(props) {
    super(props)
    this.state = { expanded: false }
  }

  private handleExpansion(event) {
    this.setState({ expanded: !this.state.expanded })
  }

  private get summaryClassName() {
    const { step: { status }, classes } = this.props
    return classnames(classes.summary, {
      [classes.failed]: status === 'failed',
      [classes.running]: status === 'running',
      [classes.done]: status === 'done',
      [classes.pending]: status === 'pending',
      [classes.cancelled]: status === 'cancelled',
    })
  }

  render() {
    const { step: { status, output, command, id }, classes } = this.props
    const { expanded } = this.state
    const running = status === 'running'

    return (
      <Paper elevation={1} square className={classnames(classes.root, { [classes.expanded]: expanded })}>
        <ButtonBase className={this.summaryClassName} onClick={this.handleExpansion.bind(this)}>
          <Typography className={classes.summaryText}>{command}</Typography>
          <ProgressExpandButton loading={running} expanded={expanded} />
        </ButtonBase>
        {expanded && <ConsoleOutput output={output} />}
      </Paper>
    )
  }
}

export default withStyles(styles as any)(Step)
