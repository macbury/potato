import gql from 'graphql-tag'

export default function updateUI(_, { title, backButtonUrl }, { cache }) {
  const query = gql`
    {
      ui @client {
        backButtonUrl
        title
      }
    }
  `
  const { ui } = cache.readQuery({ query })

  const data = {
    ui: {
      __typename: 'UI',
      backButtonUrl,
      title
    }
  }

  cache.writeData({ data })

  return null
}
