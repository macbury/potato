import * as React from 'react';
import classNames from 'classnames';
import withWidth, { isWidthUp } from '@material-ui/core/withWidth';
import { withStyles } from '@material-ui/core/styles';
import { withRouter } from "react-router"

import Drawer from '@material-ui/core/Drawer';
import IconButton from '@material-ui/core/IconButton';
import ChevronLeftIcon from '@material-ui/icons/ChevronLeft';
import MemoryIcon from '@material-ui/icons/Memory';
import Divider from '@material-ui/core/Divider';
import ListItem from '@material-ui/core/ListItem';
import ListItemIcon from '@material-ui/core/ListItemIcon';
import ListItemText from '@material-ui/core/ListItemText';
import DeveloperModeIcon from '@material-ui/icons/DeveloperMode';
import FolderIcon from '@material-ui/icons/Folder';
import LayersIcon from '@material-ui/icons/Layers';
import BarChartIcon from '@material-ui/icons/BarChart';
import List from '@material-ui/core/List';

import styles from './styles'

const SidebarItem = withRouter(function ({ text, icon, to, history }) {
  const goToPath = () => history.push(to)
  return (
    <ListItem button onClick={goToPath}>
      <ListItemIcon>{icon}</ListItemIcon>
      <ListItemText primary={text} />
    </ListItem>
  )
})

function Sidebar({ classes, width, handleDrawerClose, opened }) {
  return (
    <Drawer
      variant={isWidthUp('md', width) ? 'permanent' : 'temporary'}
      className={classNames(classes.drawer, {
        [classes.drawerOpen]: opened,
        [classes.drawerClose]: !opened,
      })}
      classes={{
        paper: classNames({
          [classes.drawerOpen]: opened,
          [classes.drawerClose]: !opened,
        }),
      }}
      open={opened}>
      <div className={classes.toolbar}>
        <IconButton onClick={handleDrawerClose}>
          <ChevronLeftIcon />
        </IconButton>
      </div>
      <Divider />
      <List>
        <SidebarItem icon={<FolderIcon />} text="Projects" to="/" />
        <SidebarItem icon={<LayersIcon />} text="Builds" to="/" />
        <SidebarItem icon={<BarChartIcon />} text="Stats" to="/" />
      </List>
      <Divider />
      <List>
        <SidebarItem icon={<DeveloperModeIcon />} text="Api Explorer" to="/api/explorer" />
        <SidebarItem icon={<MemoryIcon />} text="Workers" to="/workers" />
      </List>
    </Drawer>
  )
}

const StyledSidebar = withStyles(styles as any, { withTheme: true })(Sidebar)
export default withWidth()(StyledSidebar)
