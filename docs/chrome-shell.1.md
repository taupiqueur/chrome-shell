# chrome-shell(1)

## Name

```
chrome-shell - A native messaging host for executing shell commands.
```

## Synopsis

```
chrome-shell [options] [command]
```

## Description

chrome-shell is a native messaging host for executing shell commands.

## Usage

If no command is specified, the `run` command is assumed.

### Allow extensions to communicate with the shell application

Copy the extension IDs you want to register in the manifest and run the following in your terminal.

```
chrome-shell install [--target=<platform>] [<extension-id>...]
```

Possible targets are `chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary` and `chromium`.

### Revoke all permissions

Simply uninstall the manifest.

``` sh
chrome-shell uninstall
```

## Commands

The commands are as follows:

###### `run`

Run server.

###### `install`

Install manifest and register specified extensions.

Accepts a list of extension ID values.
Each value represents an extension which is allowed to communicate with this native application.

###### `uninstall`

Uninstall manifest.

## Options

The options are as follows:

###### `--target=<platform>`

Specifies the target platform.

Possible values are `chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary` and `chromium`.

Default is `chrome`.

###### `-h`
###### `--help`

Show this help.

###### `-v`
###### `--version`

Show version.
