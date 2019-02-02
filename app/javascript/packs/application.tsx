import 'typeface-roboto'
require('./style.scss')

import React from 'react'
import ReactDOM from 'react-dom'
import { ApolloProvider } from 'react-apollo'
import { BrowserRouter as Router, Route, Link, Switch } from 'react-router-dom'
import { MuiThemeProvider } from '@material-ui/core/styles'
import { hot } from 'react-hot-loader'

import createClient from './graphql'
import theme from './theme'

import Layout from './components/Layout'
import SignInPage from './pages/SignIn'
import AllProjectsPage from './pages/projects/all'
import CreateProjectPage from './pages/projects/create'
import ApiExplorerPage from './pages/api/explorer'
import WorkersPage from './pages/Workers'
import ShowProjectPage from './pages/projects/show'
import EditProjectPage from './pages/projects/edit'
import ShowBuildsPage from './pages/builds/show'

const MainRoute = ({ component: Component, title, ...rest }) => (
  <Route {...rest} render={props => (
    <Layout title={title}>
      <Component {...props} />
    </Layout>
  )} />
) 

document.addEventListener('DOMContentLoaded', () => {
  const root = document.getElementById('application-root')
  const state = JSON.parse(root.getAttribute('data-props'))
  const client = createClient(state)

  const Application = () => (
    <MuiThemeProvider theme={theme}>
      <ApolloProvider client={client}>
        <Router>
          <Layout>
            <Switch>
              <Route path="/"
                     exact 
                     component={AllProjectsPage} />
              <Route path="/projects" 
                     exact 
                     component={AllProjectsPage} />
              <Route path="/api/explorer" 
                     component={ApiExplorerPage} />
              <Route path="/workers" 
                     component={WorkersPage} />
              <Route path="/projects/new" 
                     exact 
                     component={CreateProjectPage} />
              <Route path="/projects/:id/edit" 
                     exact 
                     component={EditProjectPage} />
              <Route path="/projects/:projectId/builds/:id" 
                     exact 
                     component={ShowBuildsPage} />
              <Route path="/projects/:id/edit/:tab" 
                     exact 
                     component={EditProjectPage} />
              <Route path="/projects/:id" 
                     exact 
                     component={ShowProjectPage} />
              <Route path="/sign-in" 
                     component={SignInPage} />
            </Switch>
          </Layout>
        </Router>
      </ApolloProvider>
    </MuiThemeProvider>
  )

  const HotApp = hot(module)(Application)

  ReactDOM.render(<HotApp />, root)
})
