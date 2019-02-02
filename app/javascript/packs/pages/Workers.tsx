import * as React from 'react'
import { withStyles } from '@material-ui/core/styles'
import ChangeToolbar from '../components/ChangeToolbar'
const styles = (theme) => ({
  iframe: {
    border: '0px',
    width: '100%',
    height: '100%'
  }
})

function WorkersPage({ classes }) {
  return (
    <ChangeToolbar title="Sidekiq">
      <iframe src="/sidekiq/workers" className={classes.iframe}></iframe>
    </ChangeToolbar>
  )
}

export default withStyles(styles as any)(WorkersPage)
