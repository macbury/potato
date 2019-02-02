import * as React from 'react'
import { Query } from "react-apollo"

import Typography from '@material-ui/core/Typography'

import Builds from '../../components/Builds'
import Loader from '../../components/Loader'

import Content from '../../components/Content'
import ResponsivePaper from '../../components/ResponsivePaper'
import ProjectDetailsCard from '../../components/ProjectDetailsCard'
import TriggerBuildFab from '../../components/TriggerBuildFab'
import LoadMoreLoader from '../../components/LoadMoreLoader'
import ErrorContent from '../../components/ErrorContent'

import { onCurrentBuildsUpdate } from '../../graphql/subscriptions'
const currentProjectQuery = require('../../graphql/queries/currentProject')

interface IShowProjectPageProps {
  data : any;
  error : any;
  loading : boolean;
  fetchMore(options);
  subscribeToMore(options);
}

class ShowProjectPage extends React.Component<IShowProjectPageProps> {
  componentDidMount() {
    this.props.subscribeToMore(onCurrentBuildsUpdate())
  }

  private nextPage() {
    const {
      fetchMore,
      data: {
        currentProject: {
          id,
          builds: { pageInfo: { endCursor } }
        }
      }
    } = this.props
    fetchMore({
      query: currentProjectQuery,
      variables: {
        projectId: id,
        endCursor
      },
      updateQuery: ({ currentProject }, { fetchMoreResult: { currentProject: { builds: { nodes, pageInfo } } } }) => {
        return {
          currentProject: {
            ...currentProject,
            builds: {
              ...currentProject.builds,
              pageInfo,
              nodes: [...currentProject.builds.nodes, ...nodes]
            }
          }
        }
      }
    })
  }

  render() {
    if (this.props.loading && !this.props.data.currentProject) {
      return <Loader />
    }

    let { data: { currentProject }, loading } = this.props
    let { name, id, builds: { nodes, pageInfo } } = currentProject

    return (
      <Content title={currentProject.name} backButtonUrl="/">
        <ProjectDetailsCard project={currentProject} />
        <Builds builds={nodes} 
                project={currentProject} />
        {nodes.length == 0 && <ErrorContent message={I18n.t('projects.show.builds.empty')} />}
        <LoadMoreLoader loading={loading}
                        pageInfo={pageInfo}
                        fetchMore={this.nextPage.bind(this)} />
        <TriggerBuildFab projectId={currentProject.id}
                         branch="master" />
      </Content>
    )
  }
}

export default function ShowProjectPageContainer({ match: { params: { id } } }) {
  return (
    <Query query={currentProjectQuery} variables={{ projectId: parseInt(id) }} fetchPolicy="cache-and-network">
      {({ loading, error, data, fetchMore, subscribeToMore }) => {
        let props = { loading, error, data, fetchMore, subscribeToMore }
        return <ShowProjectPage {...props} />
      }}
    </Query>
  )
}
