import * as React from 'react'
import Select from 'react-select'
import { Query } from 'react-apollo'
import gql from 'graphql-tag'
import MaterialSelect from './MaterialSelect'
const FETCH_REPOSITORIES = gql`
  {
    repositories {
      name
      id
      owner
      avatarUrl
    }
  }
`

function buildOptions({ repositories }) {
  if (!repositories) {
    return []
  }

  return repositories.map(({ name, id, owner }) => {
    return { label: `${owner}/${name}`, value: id, name }
  })
}

export default function RepositorySelect({ value, onChange, disabled }) {
  return (
    <Query query={FETCH_REPOSITORIES}>
      {({ loading, error, data }) => {
        return <MaterialSelect
                  id="repository-select"
                  label={I18n.t("projects.select_repository")}
                  isLoading={loading}
                  isSearchable={true}
                  isDisabled={disabled}
                  onChange={onChange}
                  value={value}
                  options={buildOptions(data)} />
      }}
    </Query>
  )
}
