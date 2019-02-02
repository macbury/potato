import * as React from 'react'

import ShellEditor from '../../../components/ShellEditor'

interface IProps {
  currentPipelineId: number;
  pipelines: any,
  onPipelineScriptChange(content : string);
}

export default function PipelinesCard({ currentPipelineId, pipelines, onPipelineScriptChange } : IProps) {
  let currentPipeline = pipelines.find(({ id }) => currentPipelineId === id)

  return (
    <div className="card">
      <div className="card-header">
{/*        <EditorTabs
            items={pipelines}
            current={currentPipelineId}
            onClose={(id) => { console.log(`Close pipeline: ${id}`) }}
            onSelect={(id) => { console.log(`Select pipeline: ${id}`) }}
            />*/}
      </div>
      <div className="card-body">
        <h5 className="card-title">Configure Test Pipelines</h5>
        <p className="card-text">Run your tests and builds here.</p>

        <ShellEditor id="pipeline-script" value={currentPipeline.script} onChange={onPipelineScriptChange} />
      </div>
    </div>
  )
}
