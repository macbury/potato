import * as React from 'react'
import { Query } from 'react-apollo'


import AddIcon from '@material-ui/icons/Add'
import LinkFab from '../../components/LinkFab'
import Content from '../../components/Content'
import Loader from '../../components/Loader'
import LoadMoreLoader from '../../components/LoadMoreLoader'
import ProjectLists from '../../components/ProjectsList'

const projectsQuery = require('../../graphql/queries/projects')

interface IProps {
  loading: boolean;
  error: any;
  data: any;
  fetchMore(options);
}

class AllProjectsPage extends React.Component<IProps> {
  private nextPage() {
    const {
      fetchMore,
      data: {
        projects: { pageInfo: { endCursor } }
      }
    } = this.props

    fetchMore({
      query: projectsQuery,
      variables: { endCursor },

      updateQuery: ({ projects: oldProjects }, { fetchMoreResult: { projects: { nodes, pageInfo } } }) => {
        const updatedProjects = {
          ...oldProjects,
          pageInfo
        }

        updatedProjects.nodes = [...updatedProjects.nodes, ...nodes]

        return {
          projects: updatedProjects
        }
      }
    })
  }

  render() {
    const { loading, data } = this.props

    if (loading && !data.projects) {
      return <Loader />
    }

    const {
      projects: {
        nodes,
        pageInfo
      }
    } = data

    return (
      <Content>
        <ProjectLists loading={loading} projects={nodes}>
          <LoadMoreLoader loading={loading}
                          pageInfo={pageInfo}
                          fetchMore={this.nextPage.bind(this)} />
        </ProjectLists>
        <LinkFab color="primary" to="/projects/new" id="add_project">
          <AddIcon />
        </LinkFab>
      </Content>
    )
  }
}

export default function AllProjectsPageContainer(props) {
  return (
    <Query query={projectsQuery} fetchPolicy="cache-and-network">
      {({ loading, error, data, fetchMore }) => {
        let props = { loading, error, data, fetchMore }
        return <AllProjectsPage {...props} />
      }}
    </Query>
  )
}
