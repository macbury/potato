import * as React from 'react'
import { graphql, compose } from 'react-apollo'
import { withStyles } from '@material-ui/core/styles'
import { withRouter } from "react-router"
import gql from 'graphql-tag'

import IconButton from '@material-ui/core/IconButton'
import AccountCircle from '@material-ui/icons/AccountCircle'
import MenuItem from '@material-ui/core/MenuItem'
import Menu from '@material-ui/core/Menu'
import Avatar from '@material-ui/core/Avatar'

import styles from './styles'

interface IProps {
  classes : any;
  data? : {
    me: {
      avatarUrl:string;
    }
  };
}

interface IState {
  anchorEl? : any;
}

function ProfileLink({ id, href, onClick, children }) {
  return <MenuItem id={id} onClick={() => { onClick(href) }}>{children}</MenuItem>
}

class Profile extends React.Component<IProps, IState> {
  state = {
    anchorEl: null
  };

  handleClose = () => {
    this.setState({ anchorEl: null });
  };

  handleMenu = event => {
    this.setState({ anchorEl: event.currentTarget });
  };

  signOut = (href) => {
    window.location.href = href
    this.handleClose()
  }

  get profileLoaded() {
    return this.props.data && this.props.data.me
  }

  render() {
    const { anchorEl } = this.state
    const { classes, data } = this.props
    const open = Boolean(anchorEl)
    const origin = {
      vertical: 'top',
      horizontal: 'right',
    }

    return (
      <div className={classes.profile}>
        <IconButton aria-haspopup="true" color="inherit" onClick={this.handleMenu} id="user-button">
          {this.profileLoaded ? <Avatar className={classes.avatar} src={data.me.avatarUrl} /> : <AccountCircle />}
        </IconButton>

        <Menu id="menu-appbar"
              anchorEl={anchorEl}
              anchorOrigin={origin as any}
              transformOrigin={origin as any}
              open={open}
              onClose={this.handleClose}>
          <ProfileLink id="profile-button" href="/profile" onClick={this.handleClose}>Profile</ProfileLink>
          <ProfileLink id="logout-button" href="/sign-out" onClick={this.signOut}>Logout</ProfileLink>
        </Menu>
      </div>
    )
  }
}

const ME_QUERY = gql`
  {
    me {
      avatarUrl
    }
  }
`

export default compose(
  withRouter,
  graphql(ME_QUERY),
  withStyles(styles as any)
)(Profile)
