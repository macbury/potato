import * as React from 'react'
import Typography from '@material-ui/core/Typography'
import { withStyles } from '@material-ui/core/styles'

import Step from './Step'
import Octicon, { Server, Ruby } from '@githubprimer/octicons-react'

const styles = theme => ({
  container: {
    marginTop: theme.spacing.unit * 4
  },
  title: {
    marginBottom: theme.spacing.unit * 2
  },
  icon: {
    width: '26px',
    height: '26px',
    marginLeft: theme.spacing.unit,
    marginRight: theme.spacing.unit
  }
})

function Thread({ steps, classes }) {
  const { __typename, name } = steps[0].owner
  const icon = __typename == 'Image' ? Server : Ruby
  const Ikona = Octicon as any
  return (
    <div className={classes.container}>
      <Typography variant="h5" className={classes.title}>
        <Ikona icon={icon} className={classes.icon}/>
        {name}
      </Typography>
      {steps.map((step) => <Step key={`step_${step.id}`} step={step} />)}
    </div>
  )
}

export default withStyles(styles as any)(Thread)
