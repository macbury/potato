import * as React from 'react'
import AddIcon from '@material-ui/icons/Add'
import LinkFab from '../../../../components/LinkFab'
import ImageCard from './ImageCard'

export default function Images({ images, projectId }) {
  return (
    <React.Fragment>
      {images.map((image) => <ImageCard projectId={projectId} currentImage={image} key={`image_${image.id}`} />)}
      <LinkFab color="primary" to="/projects/new" id="image_new">
        <AddIcon />
      </LinkFab>
    </React.Fragment>
  )
}