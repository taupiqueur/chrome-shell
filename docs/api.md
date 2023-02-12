# API reference

API reference of the `shell` native messaging host for executing shell commands.

## Types

### Command

Property | Type | Value | Description
--- | --- | --- | ---
`command` | `String` | | The command name.
`args` | `Array(String)` | `[]` | The list of arguments passed to the command.
`env` | `Hash(String, String \| Null)` | `{}` | The list of environment variables passed to the command.
`input` | `String \| Null` | `null` | Configures *stdin* data.
`output` | `Boolean` | `false` | Captures *stdout* stream.
`error` | `Boolean` | `false` | Captures *stderr* stream.
`dir` | `String \| Null` | `null` | Sets the working directory for the child process.

### CommandResult

Property | Type | Description
--- | --- | ---
`status` | `Integer` | The exit code of the process.
`output` | `String` | Captured *stdout* stream.
`error` | `String` | Captured *stderr* stream.
