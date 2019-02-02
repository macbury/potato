import * as React from 'react'
import classNames from 'classnames';
import { compose } from 'recompose'
import { withRouter } from 'react-router'
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';
import ArrowBack from '@material-ui/icons/ArrowBack';

import styles from './styles'

function Header({ title, backButtonUrl, opened, classes, handleDrawerOpen, children, history }) {
  const backMode = backButtonUrl !== null && backButtonUrl !== ''

  function goBack() {
    history.push(backButtonUrl)
  }

  return (
    <AppBar
      position="fixed"
      className={classNames(classes.appBar, {
        [classes.appBarShift]: opened,
      })} >
      <Toolbar disableGutters={true}>
        <IconButton
          color="inherit"
          onClick={backMode ? goBack : handleDrawerOpen}
          className={classNames(classes.menuButton, {
            [classes.hide]: opened,
          })}>
          { backMode ? <ArrowBack /> : <MenuIcon /> }
        </IconButton>
        <Typography variant="h6" color="inherit" noWrap className={classNames(classes.logo, {
          [classes.logoOpened]: opened
        })}>
          {title ? title : 'Potato'}
        </Typography>
        {children}
      </Toolbar>
    </AppBar>
  )
}

export default compose(
  withRouter,
  withStyles(styles as any, { withTheme: true })
)(Header)
