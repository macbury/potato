const fetchProjectForSettings = require('../queries/fetchProjectForSettings')

export default function updateLocalLImage(_, { projectId, attributes }, { cache }) {
  const { currentProject } = cache.readQuery({
    query: fetchProjectForSettings,
    variables: { projectId }
  })

  const updatedProject = {
    ...currentProject,
    images: currentProject.images.map((oldImage) => {
      if (oldImage.id === attributes.id) {
        return {...oldImage, ...attributes}
      } else {
        return oldImage
      }
    })
  }

  cache.writeQuery({
    query: fetchProjectForSettings,
    variables: { projectId },
    data: { currentProject: updatedProject }
  })

  return null;
}
