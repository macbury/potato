import React from 'react'
import Button from '@material-ui/core/Button'
import { withStyles } from '@material-ui/core/styles'

import Octicon, { Octoface } from '@githubprimer/octicons-react'
const LogoSvgUrl = require('../svg/logo.svg')

const styles = theme => ({
  content: {
    maxWidth: '320px',
    margin: '0 auto',
    height: '100%',
    display: 'flex',
    alignItems: 'center',
    flexDirection: 'column',
    justifyContent: 'center'
  },

  button: {
    marginTop: '20px'
  },

  logo: {
    width: '128px',
  },

  icon: {
    marginRight: '10px'
  }
})

function SignInPage({ classes }) {
  return (
    <div className={classes.content}>
      <img src={LogoSvgUrl} className={classes.logo} />
      <Button variant="outlined" color="primary" size="large" href="/users/auth/github" className={classes.button}>
        <span className={classes.icon}><Octicon icon={Octoface}/></span>
        {I18n.t('session.new.sign_in')}
      </Button>
    </div>
  )
}

export default withStyles(styles as any)(SignInPage)
