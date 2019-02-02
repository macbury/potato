import * as React from 'react'
import gql from 'graphql-tag'
import { Mutation, graphql, compose } from "react-apollo"
import { withRouter } from "react-router"
import { WithStyles, createStyles, withStyles, Theme } from '@material-ui/core'
import Grid from '@material-ui/core/Grid'
import TextField from '@material-ui/core/TextField'
import Typography from '@material-ui/core/Typography'
import Button from '@material-ui/core/Button'

import Content from '../../components/Content'
import RepositorySelect from '../../components/RepositorySelect'
import ResponsivePaper from '../../components/ResponsivePaper'

const addNoticeMutation = require('../../graphql/queries/mutations/addNotice')
const createProjectMutation = require('../../graphql/queries/mutations/createProject')

const styles = (theme : Theme) => createStyles({
  buttons: {
    display: 'flex',
    justifyContent: 'flex-end',
  },
  button: {
    marginTop: theme.spacing.unit * 3,
    marginLeft: theme.spacing.unit,
  },
})

interface IProps extends WithStyles<typeof styles> {
  createProjectMutation(options);
  addNoticeMutation(options);
  history: any;
  loading : boolean;
  data : {
    createProject: {
      name : string;
      id : number;
    }
    errors: String[]
  };
  error : any;
}

interface IState {
  repository: { value: number, label: string };
  name: string;
  loading: boolean;
  errors: string[];
}

const INITIAL_STATE : IState = {
  repository: null,
  name: '',
  loading: false,
  errors: []
}

class CreateProjectForm extends React.Component<IProps, IState> {
  constructor(props) {
    super(props)
    this.state = {...INITIAL_STATE}
  }

  async handleSubmit(e) {
    e.preventDefault()
    this.setState({ loading: true, errors: [] })

    let { repository, name } = this.state
    let value = repository ? repository.value : -1

    let { data, errors } = await this.props.createProjectMutation({
      variables: { repositoryId: value, name }
    })

    let { createProject: { project } } = data
    errors = errors ? errors : data.createProject.errors

    if (project) {
      this.props.history.replace(`/projects/${project.id}`)
      this.props.addNoticeMutation({ variables: { message: I18n.t('projects.create.flashes.success') } })
    } else {
      this.setState({ errors, loading: false })
    }
  }

  onNameChange(e : React.ChangeEvent<HTMLInputElement>) {
    this.setState({
      name: e.currentTarget.value
    })
  }

  onRepoChange({ label, value, name }) {
    if (this.state.name.length > 0) {
      name = this.state.name
    }

    this.setState({
      repository: { label, value },
      name
    })
  }

  render() {
    let { repository, name, loading, errors } = this.state
    let { classes, history } = this.props
    return (
      <Content title="New project" backButtonUrl="/">
        <ResponsivePaper form>
          <Typography variant="h6" gutterBottom>
            {I18n.t('projects.create.header')}
          </Typography>
          <Grid container spacing={24}>
            <Grid item xs={12}>
              <RepositorySelect value={repository}
                             disabled={loading}
                             onChange={this.onRepoChange.bind(this)}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                  id="project-name"
                  disabled={loading}
                  label={I18n.t('projects.form.create.name')}
                  onChange={this.onNameChange.bind(this)}
                  value={name}
                  error={errors.length > 0}
                  fullWidth
                  helperText={errors.join(',')}
                />
            </Grid>
          </Grid>

          <div className={classes.buttons}>
            <Button variant="contained" className={classes.button} disabled={loading} onClick={() => history.push('/projects')}>
              {I18n.t('projects.form.create.cancel')}
            </Button>
            <Button variant="contained" color="primary" disabled={loading} className={classes.button} onClick={this.handleSubmit.bind(this)}>
              {I18n.t('projects.form.create.button')}
            </Button>
          </div>
        </ResponsivePaper>
      </Content>
    )
  }
}

export default compose(
  graphql(createProjectMutation, { name: 'createProjectMutation' }),
  graphql(addNoticeMutation, { name: 'addNoticeMutation' }),
)(withStyles(styles)(withRouter(CreateProjectForm)));
