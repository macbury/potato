import React from 'react'
import classnames from 'classnames'
import { graphql, compose } from 'react-apollo'
import gql from 'graphql-tag'
import Flashes from '../Flashes'
import Loader from '../Loader'

import Wrapper from './wrapper'

interface IProps {
  classes: any;
  data: {
    loading: boolean;
    flash: any,
    signedIn?: boolean;
    ui: {
      title: string;
      backButtonUrl?: string;
    }
  }
}

class Layout extends React.Component<IProps> {
  render() {
    if (this.props.data.loading) {
      return <Loader />
    }
    const { data: { signedIn, flash, ui: { title, backButtonUrl } }, children } = this.props

    return (
      <React.Fragment>
        <Flashes flash={flash} />
        <Wrapper signedIn={signedIn} title={title} backButtonUrl={backButtonUrl}>
          {children}
        </Wrapper>
      </React.Fragment>
    )
  }
}

const PREPARE_LAYOUT_QUERY = gql`
  {
    signedIn @client
    flash @client {
      id
      message
      type
    }
    ui @client {
      title
      backButtonUrl
    }
  }
`

export default compose(
  graphql(PREPARE_LAYOUT_QUERY)
)(Layout);
