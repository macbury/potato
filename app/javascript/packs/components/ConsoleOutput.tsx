import * as React from 'react'
import Ansi from 'ansi-to-react'
import { withStyles } from '@material-ui/core/styles'

interface IProps {
  output : string[];
  classes: any;
}

const styles = theme => ({
  root: {
    overflowX: 'auto',
    padding: '16px 24px',
    background: '#000',
    color: '#fff',
    margin: '0px',
    lineHeight: '20px'
  }
})

class ConsoleOutput extends React.Component<IProps> {
  render() {
    const { output, classes } = this.props
    return <pre className={classes.root}><Ansi>{output.join('')}</Ansi></pre>
  }
}

export default withStyles(styles as any)(ConsoleOutput)