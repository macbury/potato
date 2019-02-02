import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { withStyles } from '@material-ui/core/styles';
import CssBaseline from '@material-ui/core/CssBaseline';

import styles from './styles'
import Header from './header'
import Sidebar from './sidebar'
import Profile from './profile'

interface IProps {
  signedIn: boolean;
  theme?: any;
  width?: string;
  classes?: any;
  title: string;
  backButtonUrl?: string;
}

interface IState {
  open: boolean;
}

class MiniDrawer extends React.Component<IProps, IState> {
  state = {
    open: false,
  };

  handleDrawerOpen = () => {
    this.setState({ open: true });
  };

  handleDrawerClose = () => {
    this.setState({ open: false });
  };

  get sidebarVisible() {
    return this.props.signedIn && (this.props.backButtonUrl === null || this.props.backButtonUrl === '')
  }

  render() {
    const { open } = this.state
    const { classes, theme, children, width, signedIn, title, backButtonUrl } = this.props;

    return (
      <div className={classes.root}>
        <CssBaseline />
        {signedIn && <Header
          opened={open && this.sidebarVisible}
          title={title}
          backButtonUrl={backButtonUrl}
          handleDrawerOpen={this.handleDrawerOpen}>
          <Profile />
        </Header>}

        {this.sidebarVisible && <Sidebar
          opened={open}
          handleDrawerClose={this.handleDrawerClose} /> }

        <main className={classes.content}>
          <div className={classNames({ [classes.toolbar]: signedIn })} />
          {children}
        </main>
      </div>
    );
  }
}

export default withStyles(styles as any, { withTheme: true })(MiniDrawer)
