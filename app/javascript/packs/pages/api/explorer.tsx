import * as React from 'react'
import ReactDOM from 'react-dom'
import fetch from 'isomorphic-fetch'
import { withStyles } from '@material-ui/core/styles';
import { graphQLFetcher } from "graphiql-subscriptions-fetcher/dist/fetcher"
import ActionCable from 'actioncable'
import Loader from '../../components/Loader'
import ChangeToolbar from '../../components/ChangeToolbar'
import GraphiQL from 'graphiql'

const cable = ActionCable.createConsumer()

class ActionCableSubscriber {
  cable : ActionCable;
  registry : object;

  constructor(cable) {
    this.cable = cable
    this.registry = {}
  }

  unsubscribe(channelId) {
    if (this.registry[channelId] != null){
      this.registry[channelId].unsubscribe()
      this.registry[channelId] = null
    }
  }

  subscribe(graphQLParams, callback) {
    const channelId = this.getUuid()

    const channel = this.cable.subscriptions.create({
      channel: "GraphqlChannel",
      channelId
    }, {
      connected: () => {
        channel.perform('execute', graphQLParams)
      },

      rejected: () => {
        callback(new Error('Connection rejected from server'), null)
      },

      received: (payload) => {
        if (payload.result && payload.result.data) {
          callback(null, payload.result.data);
        }

        if (!payload.more) {
          this.unsubscribe(channelId)
        }
      }
    })
    this.registry[channelId] = channel
    return channelId
  }

  private getUuid() {
    return Math.round(Date.now() + Math.random() * 100000).toString(16)
  }
}

const fetcher = graphQLFetcher((new ActionCableSubscriber(cable) as any), function (graphQLParams) {
  return fetch(window.location.origin + '/api', {
    method: 'post',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(graphQLParams),
  }).then(response => response.json());
})

interface IState {
  loading: boolean,
  Component: any
}

const styles = theme => ({
  content: {
    height: '100%'
  }
})

function ApiExplorer({ classes }) {
  return (
    <div className={classes.content}>
      <ChangeToolbar title="Api Explorer" />
      <GraphiQL fetcher={fetcher} />
    </div>
  )
}

export default withStyles(styles as any)(ApiExplorer)
