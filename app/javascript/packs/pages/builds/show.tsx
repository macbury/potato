import * as React from 'react'
import { Query } from 'react-apollo'

import Loader from '../../components/Loader'
import Content from '../../components/Content'
import BuildDetails from '../../components/Build/Details'
import Threads from '../../components/Threads'
import TriggerBuildFab from '../../components/TriggerBuildFab'
import { onBuildUpdate, onStepOutput } from '../../graphql/subscriptions'

const currentBuildQuery = require('../../graphql/queries/currentBuild')

interface IShowBuildPageProps {
  data : any;
  error : any;
  loading : boolean;
  buildId : number;
  subscribeToMore(options);
}

class ShowBuildPage extends React.Component<IShowBuildPageProps> {
  private subscriptionsEnabled = false

  componentDidMount() {
    this.subscribeToUpdates(this.props)
  }

  componentWillReceiveProps(nextProps : IShowBuildPageProps) {
    this.subscribeToUpdates(nextProps)
  }

  private subscribeToUpdates(nextProps) {
    const { subscribeToMore, loading, data, buildId } = nextProps

    if (this.props.buildId != nextProps.buildId) {
      this.subscriptionsEnabled = false
    }

    if (!this.subscriptionsEnabled && !loading) {
      console.log('Subscribing...')
      subscribeToMore(onBuildUpdate(data.currentBuild.id))

      nextProps.data.currentBuild.steps.forEach(({ id }) => {
        subscribeToMore(onStepOutput(id))
      })

      this.subscriptionsEnabled = true
    }
  }

  render() {
    if (this.props.loading) {
      return <Loader />
    }

    let { data: { currentBuild } } = this.props

    return (
      <Content title={`Build #${currentBuild.number} of ${currentBuild.project.name}/${currentBuild.branch}`} backButtonUrl={`/projects/${currentBuild.project.id}`}>
        <BuildDetails build={currentBuild} />
        <Threads steps={currentBuild.steps}/>
        <TriggerBuildFab projectId={currentBuild.project.id}
                         branch={currentBuild.branch}
                         sha={currentBuild.sha} />
      </Content>
    )
  }
}

export default function ShowBuildPageContainer({ match: { params: { id } } }) {
  const buildId = parseInt(id)
  return (
    <Query query={currentBuildQuery} variables={{ buildId }} fetchPolicy="cache-and-network">
      {({ loading, error, data, subscribeToMore }) => {
        let props = { loading, error, data, subscribeToMore, buildId }
        return <ShowBuildPage {...props} />
      }}
    </Query>
  )
}
