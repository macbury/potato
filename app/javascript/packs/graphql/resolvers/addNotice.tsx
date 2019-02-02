import gql from 'graphql-tag'

export default function addNotice(_, { message }, { cache }) {
  const query = gql`
    {
      flash @client {
        id
        message
        type
        __typename
      }
    }
  `
  const { flash } = cache.readQuery({ query })
  const id = Math.round(Date.now() + Math.random() * 100000).toString(16)
  const data = {
    flash: [...flash, { __typename: 'FlashMessage', type: 'success', id: `time_${id}`, message }]
  }

  cache.writeData({ data })

  return null
}
