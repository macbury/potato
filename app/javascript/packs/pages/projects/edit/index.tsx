import * as React from 'react'
import gql from 'graphql-tag'
import { Query } from 'react-apollo'
import Loader from '../../../components/Loader'

import ProjectSettingsCard from '../../../components/ProjectSettingsCard'
import CenteredContent from '../../../components/CenteredContent'
import Images from './Images'

const FETCH_PROJECT_AND_IMAGES_AND_PIPELINES_QUERY = require('../../../graphql/queries/fetchProjectForSettings')

interface IProject {
  id : number;
  name : string;
  images : [
    {
      id : number,
      name : string;
      caches: string[];
      buildScript : string;
      setupScript : string;
    }
  ],
  pipelines : [
    {
      id : number;
      name : string;
      script : string;
    }
  ]
}

interface IProps {
  loading : boolean;
  error : object;
  tab : string;
  currentProject?: IProject
}

class EditProject extends React.Component<IProps> {
  get currentTab() {
    return this.props.tab || 'images'
  }

  render() {
    let { loading } = this.props

    if (loading) {
      return <Loader />
    }

    let {
      currentProject: {
        id,
        name,
        images,
        pipelines
      }
    } = this.props

    return (
      <CenteredContent title={`Settings for ${name}`} backButtonUrl={`/projects/${id}`}>
        <ProjectSettingsCard project={this.props.currentProject} tab={this.currentTab} />
        {this.currentTab == 'images' && <Images images={images} projectId={id} />}
      </CenteredContent>
    )
  }
}

export default function EditPageContainer({ match: { params: { id, tab } } }) {
  return (
    <Query query={FETCH_PROJECT_AND_IMAGES_AND_PIPELINES_QUERY} variables={{ projectId: parseInt(id) }} >
      {({ loading, error, data: { currentProject } }) => {
        let props = { loading, error, currentProject }
        return <EditProject tab={tab} {...props} />
      }}
    </Query>
  )
}
