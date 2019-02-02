import * as React from 'react'
import Snackbar from '@material-ui/core/Snackbar'
import IconButton from '@material-ui/core/IconButton'
import CloseIcon from '@material-ui/icons/Close'

interface IProps {
  type: string;
  message: string;
}

interface IState {
  closed: boolean;
}

class Flash extends React.Component<IProps, IState> {
  state = {
    closed: false
  }

  handleClose() {
    this.setState({ closed: true })
  }

  render() {
    if (this.state.closed) {
      return null;
    }

    let { message, type } = this.props

    const actions = [
      <IconButton key="close" onClick={this.handleClose.bind(this)} >
        <CloseIcon />
      </IconButton>
    ]

    return <Snackbar anchorOrigin={{
                        vertical: 'bottom',
                        horizontal: 'left',
                     }}
                     open={!this.state.closed}
                     autoHideDuration={6000}
                     onClose={this.handleClose.bind(this)}
                     message={message} 
                     action={actions}
                     />
  }
}

export default function Flashes({ flash }) {
  return flash.map(({ id, type, message }) => {
    return <Flash key={`flash-${id}`} type={type} message={message} />
  })
}
