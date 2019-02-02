import * as React from 'react'
import { compose } from 'recompose'
import { withRouter } from "react-router"
import { withStyles } from '@material-ui/core/styles'

import Card from '@material-ui/core/Card'
import CardHeader from '@material-ui/core/CardHeader'
import IconButton from '@material-ui/core/IconButton'
import MoreVertIcon from '@material-ui/icons/MoreVert'
import MenuItem from '@material-ui/core/MenuItem'
import Menu from '@material-ui/core/Menu'

const styles = (theme) => ({
  card: {
    maxWidth: '960px',
    margin: 'auto',
    marginBottom: theme.spacing.unit * 4,
    [theme.breakpoints.down('xs')]: {
      borderRadius: '0px'
    }
  },
})

interface IState {
  anchorEl? : any;
}

interface IProps {
  classes : any;
  history : any;
  project: {
    name: string;
    git: string;
    id: string;
  }
}

function DetailsLink({ href, onClick, children }) {
  return <MenuItem onClick={() => { onClick(href) }}>{children}</MenuItem>
}

class ProjectDetailsCard extends React.Component<IProps, IState> {
  constructor(props) {
    super(props)
    this.state = {}
  }

  handleClose() {
    this.setState({ anchorEl: null })
  }

  onRedirect(href) {
    this.setState({ anchorEl: null })
    this.props.history.push(href)
  }

  handleMenu(event) {
    this.setState({ anchorEl: event.currentTarget })
  }

  render() {
    const { anchorEl } = this.state
    const open = Boolean(anchorEl)
    const { project: { name, git, id }, classes, history, children } = this.props
    const origin = {
      vertical: 'top',
      horizontal: 'right',
    }

    return (
      <Card className={classes.card}>
        <CardHeader
          title={name}
          subheader={git}
          action={
            <IconButton onClick={this.handleMenu.bind(this)}>
              <MoreVertIcon />
            </IconButton>
          }
        />
        {children}
        <Menu id="project-appbar"
              anchorEl={anchorEl}
              anchorOrigin={origin as any}
              transformOrigin={origin as any}
              open={open}
              onClose={this.handleClose}>
          <DetailsLink href={`/projects/${id}/edit`} onClick={this.onRedirect.bind(this)}>Settings</DetailsLink>
          <DetailsLink href={`/projects/${id}`} onClick={this.onRedirect.bind(this)}>Builds</DetailsLink>
        </Menu>
      </Card>
    )
  }
}


export default compose(
  withRouter,
  withStyles(styles as any)
)(ProjectDetailsCard)
