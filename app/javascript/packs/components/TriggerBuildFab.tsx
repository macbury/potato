import * as React from 'react'
import { graphql, compose } from 'react-apollo'
import { withRouter } from 'react-router'
import { withStyles } from '@material-ui/core/styles'

import PlayIcon from '@material-ui/icons/PlayArrow'
import Fab from '@material-ui/core/Fab'
import CircularProgress from '@material-ui/core/CircularProgress'

const addNoticeMutation = require('../graphql/queries/mutations/addNotice')
const createBuildMutation = require('../graphql/queries/mutations/createBuild')

interface IProps {
  history?: any;
  classes?: any;
  projectId: number;
  branch?: string;
  sha?: string;
  createBuild?(options);
  addNotice?(options);
}

interface IState {
  loading: boolean;
}

const styles = theme => ({
  fab: {
    position: 'fixed',
    bottom: theme.spacing.unit * 2,
    right: theme.spacing.unit * 2,
    zIndex: 1000
  },
  fabProgress: {
    position: 'absolute',
    top: -6,
    left: -6,
    zIndex: 1,
  },
})

class TriggerBuildFab extends React.Component<IProps, IState> {
  constructor(props) {
    super(props)
    this.state = { loading: false }
  }

  async onFabClick() {
    this.setState({ loading: true })
    try {
      const { projectId, history, branch, sha } = this.props
      const variables = { projectId }
      const { data: { createBuild: { build, errors } } } = await this.props.createBuild({ variables })
      this.setState({ loading: false })
      if (build) {
        history.push(`/projects/${projectId}/builds/${build.id}`)
      } else {
        this.props.addNotice({ variables: { message: errors.join(',') } })
      }
    } catch (e) {
      this.props.addNotice({ variables: { message: e.toString() } })
      console.error(e)
      this.setState({ loading: false })
    }
  }

  render() {
    const { classes } = this.props
    const { loading } = this.state
    return (
      <div className={classes.fab}>
        <Fab color="primary" id="trigger_build" disabled={loading} onClick={this.onFabClick.bind(this)}>
          <PlayIcon />
        </Fab>
        {loading && <CircularProgress size={68} className={classes.fabProgress} />}
      </div>
    )
  }
}

export default compose(
  graphql(createBuildMutation, { name: 'createBuild' }),
  graphql(addNoticeMutation, { name: 'addNotice' }),
  withRouter,
  withStyles(styles as any)
)(TriggerBuildFab)
