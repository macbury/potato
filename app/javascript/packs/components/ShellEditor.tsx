import * as React from 'react'
import MonacoEditor from 'react-monaco-editor'

const options = {
  selectOnLineNumbers: true,
  fontSize: 14,
  minimap: { enabled: false },
  scrollBeyondLastLine: false,
  automaticLayout: true,
  lineNumbers: (lineNumber : number) => `Step: ${lineNumber}`,
  lineNumbersMinChars: 11
};

const style = {
  marginTop: '20px',
  marginBottom: '20px',
  padding: '20px',
  background: '#1e1e1e',
  borderRadius: '5px',
  width: '100%'
}

interface IProps {
  value : string;
  onChange?(content : string);
  id : string;
}

export default function ShellEditor({ value, onChange, id } : IProps) {
  return (
    <div style={style} id={id}>
      <MonacoEditor
        height="340px"
        language="shell"
        theme="vs-dark"
        value={value}
        options={options}
        onChange={onChange}
      />
    </div>
  )
}
