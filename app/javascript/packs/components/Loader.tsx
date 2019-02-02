import * as React from 'react'
import CircularProgress from '@material-ui/core/CircularProgress';

export default function Loader() {
  return (
    <div style={ { margin: '90px 0px', alignContent: 'center', justifyContent: 'center', display: 'flex' } }>
      <CircularProgress />
    </div>
  )
}
