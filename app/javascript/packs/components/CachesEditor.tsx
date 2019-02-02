import * as React from 'react'
import MonacoEditor from 'react-monaco-editor'

const options = {
  selectOnLineNumbers: true,
  fontSize: 14,
  minimap: { enabled: false },
  scrollBeyondLastLine: false,
  automaticLayout: true,
  lineNumbers: (lineNumber : number) => `Path: ${lineNumber}`,
  lineNumbersMinChars: 20
};

const style = {
  marginTop: '20px',
  marginBottom: '20px',
  padding: '20px',
  background: '#1e1e1e',
  borderRadius: '5px'
}

interface IProps {
  value : string[];
  onChange?(content : string[]);
  id : string;
}

export default function CachesEditor({ value, onChange, id } : IProps) {
  return (
    <div style={style} id={id}>
      <MonacoEditor
        height="100px"
        language="text"
        theme="vs-dark"
        value={value.join("\n")}
        options={options}
        onChange={(content) => onChange(content.split("\n"))}
      />
    </div>
  )
}
