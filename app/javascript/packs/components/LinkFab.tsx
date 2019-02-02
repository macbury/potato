import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import { withRouter } from "react-router"
import Fab from '@material-ui/core/Fab'

const styles = theme => ({
  fab: {
    position: 'fixed',
    bottom: theme.spacing.unit * 2,
    right: theme.spacing.unit * 2,
  },
})

interface IProps {
  color : any;
  classes? : any;
  children? : any;
  history? : any;
  to?: string;
  id?: string;
  onClick?();
}

function LinkFab({ color, classes, children, history, to, onClick, id } : IProps) {
  const clickCb = onClick ? onClick : () => history.push(to)
  return (
    <Fab className={classes.fab} color={color} onClick={clickCb} id={id}>
      {children}
    </Fab>
  )
}

export default withStyles(styles as any)(withRouter(LinkFab))
