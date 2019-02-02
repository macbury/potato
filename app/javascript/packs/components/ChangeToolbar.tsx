import * as React from 'react'
import { graphql } from 'react-apollo'
const updateUIMutation = require('../graphql/queries/mutations/updateUI')

interface IProps {
  title: string;
  children?: any;
  backButtonUrl?: string;
  updateUI?(options);
}

function ChangeToolbar({ updateUI, title, backButtonUrl, children } : IProps) {
  title = title ? title : ''
  backButtonUrl = backButtonUrl ? backButtonUrl : ''
  updateUI({ variables: { title, backButtonUrl } })
  return children ? children : null
}

export default graphql<any, any, any>(updateUIMutation, { name: 'updateUI' })(ChangeToolbar)
