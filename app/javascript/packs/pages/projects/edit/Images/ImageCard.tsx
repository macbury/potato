import * as React from 'react'
import gql from 'graphql-tag'
import { compose, graphql } from 'react-apollo'
import { withStyles, Theme } from '@material-ui/core'
import Typography from '@material-ui/core/Typography'

import ShellEditor from '../../../../components/ShellEditor'
import CachesEditor from '../../../../components/CachesEditor'
import LinkFab from '../../../../components/LinkFab'

import AddIcon from '@material-ui/icons/Add'
import Button from '@material-ui/core/Button'

import ExpansionPanel from '@material-ui/core/ExpansionPanel'
import ExpansionPanelSummary from '@material-ui/core/ExpansionPanelSummary'
import ExpansionPanelDetails from '@material-ui/core/ExpansionPanelDetails'
import ExpandMoreIcon from '@material-ui/icons/ExpandMore'
import ExpansionPanelActions from '@material-ui/core/ExpansionPanelActions'
import Divider from '@material-ui/core/Divider'
import LinearProgress from '@material-ui/core/LinearProgress'

const saveImageQuery = require('../../../../graphql/queries/mutations/saveImage')
const updateLocalImageQuery = require('../../../../graphql/queries/mutations/updateLocalImage')
const addNoticeMutation = require('../../../../graphql/queries/mutations/addNotice')

interface IProps {
  currentImage: any;
  loading: false;
  classes: any;
  projectId: number;
  updateLocalImage(options);
  saveImage(options);
  addNotice(options);
}

interface IState {
  loading?: boolean;
}

const styles = (theme : Theme) => ({
  button: {
    marginRight: theme.spacing.unit * 2,
  },
})

class ImageCard extends React.Component<IProps, IState> {
  constructor(props) {
    super(props)
    this.state = {}
  }

  private async saveChanges() {
    const {
      currentImage: {
        buildScript,
        setupScript,
        caches,
        id,
        name
      },
      saveImage,
      addNotice
    } = this.props

    this.setState({ loading: true })

    const attributes = { name, buildScript, setupScript, caches, id }

    const { data, errors } = await saveImage({ variables: { attributes } })
    if (errors) {
      addNotice({ variables: { message: errors.join(',') } })
    } else {
      addNotice({ variables: { message: I18n.t('projects.edit.flashes.image.success') } })
    }

    this.setState({ loading: false })
  }

  private onFieldUpdate(field, value) {
    const { currentImage, updateLocalImage, projectId } = this.props

    const variables = {
      projectId,
      image: {
        ...currentImage,
        [field]: value
      }
    }

    updateLocalImage({ variables })
  }

  render() {
    const {
      currentImage: {
        name, buildScript, setupScript, caches
      },
      classes
    } = this.props

    const { loading } = this.state

    return (
      <ExpansionPanel>
        <ExpansionPanelSummary expandIcon={<ExpandMoreIcon />}>
          <Typography>
            {name}
          </Typography>
        </ExpansionPanelSummary>

        <ExpansionPanelDetails>
          <div>
            <Typography variant="h6" gutterBottom>
              {I18n.t('projects.edit.images.setup_commands.heading')}
            </Typography>
            <Typography variant="body1" gutterBottom>
              {I18n.t('projects.edit.images.setup_commands.description')}
            </Typography>
            <ShellEditor id="image-build-script"
                         value={buildScript}
                         onChange={this.onFieldUpdate.bind(this, 'buildScript')} />

            <Typography variant="h6" gutterBottom>
              {I18n.t('projects.edit.images.prepare_commands.heading')}
            </Typography>
            <Typography variant="body1" gutterBottom>
              {I18n.t('projects.edit.images.prepare_commands.description')}
            </Typography>
            <ShellEditor id="image-setup-script"
                         value={setupScript}
                         onChange={this.onFieldUpdate.bind(this, 'setupScript')} />

            <Typography variant="h6" gutterBottom>
              {I18n.t('projects.edit.images.caches.heading')}
            </Typography>
            <Typography variant="body1" gutterBottom>
              {I18n.t('projects.edit.images.caches.description')}
            </Typography>
            <CachesEditor id="image-caches"
                          value={caches}
                          onChange={this.onFieldUpdate.bind(this, 'caches')} />
          </div>
        </ExpansionPanelDetails>
        <Divider />
        <ExpansionPanelActions>
          <Button className={classes.button}
                  size="small"
                  color="primary"
                  onClick={this.saveChanges.bind(this)}
                  disabled={loading}>
            {loading ? 'Saving...' : 'Save changes'}
          </Button>
       </ExpansionPanelActions>
       {loading && <LinearProgress />}
      </ExpansionPanel>
    )
  }
}

export default compose(
  graphql(addNoticeMutation, { name: 'addNotice' }),
  graphql(saveImageQuery, { name: 'saveImage' }),
  graphql(updateLocalImageQuery, { name: 'updateLocalImage' }),
  withStyles(styles as any)
)(ImageCard)
