import * as React from 'react'
import VisibilitySensor from 'react-visibility-sensor'
import CircularProgress from '@material-ui/core/CircularProgress';

interface IProps {
  loading: boolean;
  pageInfo: {
    endCursor: boolean;
    hasNextPage: boolean;
  }
  fetchMore();
}

interface IState {
  isVisible?: boolean;
  endCursorChanged?: boolean;
}

function Loader() {
  return (
    <div style={ { margin: '5px 0px', paddingBottom: '10px', alignContent: 'center', justifyContent: 'center', display: 'flex' } }>
      <CircularProgress />
    </div>
  )
}

export default class LoadMoreLoader extends React.Component<IProps, IState> {
  constructor(props) {
    super(props)
    this.state = {}
  }

  componentDidMount() {
    if (this.props.pageInfo) {
      this.setState({ endCursorChanged: true })
    }
  }

  componentWillReceiveProps({ pageInfo } : IProps) {
    if (this.props.pageInfo && this.props.pageInfo.endCursor != pageInfo.endCursor) {
      this.setState({ endCursorChanged: true })
    }
  }

  private onVisibilityChange(isVisible) {
    this.setState({ isVisible })
  }

  componentDidUpdate() {
    const { isVisible, endCursorChanged } = this.state

    if (isVisible && endCursorChanged) {
      const { fetchMore, pageInfo: { hasNextPage } } = this.props
      if (hasNextPage) {
        fetchMore()
      }
      this.setState({ endCursorChanged: false })
    }
  }

  render() {
    const { loading, pageInfo } = this.props

    if (loading) {
      return <Loader />
    }

    return (
      <VisibilitySensor onChange={this.onVisibilityChange.bind(this)}
                        intervalCheck="true"
                        active={pageInfo.hasNextPage}
                        scrollCheck="true"
                        resizeCheck="true">
        {pageInfo.hasNextPage ? <Loader /> : <span />}
      </VisibilitySensor>
    )
  }
}
