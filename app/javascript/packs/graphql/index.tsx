import ActionCable from 'actioncable'
import { InMemoryCache, IntrospectionFragmentMatcher } from 'apollo-cache-inmemory'
import { ApolloLink } from 'apollo-link'
import { ApolloClient } from 'apollo-client'
import { onError } from 'apollo-link-error'
import { HttpLink } from 'apollo-link-http'
import ActionCableLink from 'graphql-ruby-client/subscriptions/ActionCableLink'
import { withClientState } from 'apollo-link-state'

import addNotice from './resolvers/addNotice'
import updateUI from './resolvers/updateUI'
import updateLocalImage from './resolvers/updateLocalImage'

const introspectionQueryResultData = require('./fragmentTypes.json')
const cable = ActionCable.createConsumer()

const fragmentMatcher = new IntrospectionFragmentMatcher({
  introspectionQueryResultData
});

const cache = new InMemoryCache({ fragmentMatcher })

const httpLink = new HttpLink({
  uri: '/api',
  credentials: 'include'
});

const logoutLink = onError(({ networkError }) => {
  //if (networkError.statusCode === 401) { window.location.href = '/' } // TODO: this crash as fuck
})

const hasSubscriptionOperation = ({ query: { definitions } }) => {
  return definitions.some(
    ({ kind, operation }) => kind === 'OperationDefinition' && operation === 'subscription'
  )
}

const resolvers = {
  Mutation: {
    addNotice,
    updateUI,
    updateLocalImage
  }
}

const INITIAL_STATE = {
  flash: [],
  ui: {
    backButtonUrl: null,
    title: "Potato",
    __typename: 'UI'
  }
}

const defaultOptions = {
}

export default function createClient(state) {
  const stateLink = withClientState({
    cache,
    resolvers,
    defaults: {...INITIAL_STATE, ...state}
  })

  //httpLink.concat(logoutLink)

  const subscriptionLink = ApolloLink.split(
    hasSubscriptionOperation,
    new ActionCableLink({cable}),
    httpLink
  )

  const link = ApolloLink.from([stateLink, subscriptionLink])

  const client = new ApolloClient({
    link,
    cache,
    defaultOptions
  })
  return client
}
