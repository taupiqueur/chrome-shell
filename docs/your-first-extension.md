# Your first extension

This article walks through creating an extension for Chrome, from start to finish.
The extension adds a new button to the Chrome toolbar.
When the user clicks the button, we `echo` “Hello, World!” to *stdout* and log the result back into the service worker’s console.

The source code for this example is available at [/samples/hello-world].

[/samples/hello-world]: /samples/hello-world

## Declare permissions

The extension must request the `nativeMessaging` permission in the manifest file.

Example `manifest.json` file:

``` json
{
  "name": "Hello, World!",
  "version": "0.1.0",
  "description": "Native messaging example extension.",
  "manifest_version": 3,
  "background": {
    "service_worker": "background.js"
  },
  "permissions": ["nativeMessaging"],
  "action": {
    "default_title": "Click to send a message"
  }
}
```

## Allow native messaging with the shell application

Also, the native application—`chrome-shell`—must grant permission for the extension to communicate with it.

To do so, copy your extension ID and run the following in your terminal.

```
chrome-shell install [--target=<platform>] [<extension-id>...]
```

Possible targets are `chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary` and `chromium`.

## Running shell commands

Here’s an example writing “Hello, World!” to *stdout* whenever the user clicks the browser action.

``` javascript
chrome.action.onClicked.addListener(async _ => {
  const result = await chrome.runtime.sendNativeMessage('shell', {
    command: 'echo',
    args: ['Hello, World!'],
    output: true
  })
  console.log(result.status, result.output)
})
```

Here’s the example above, rewritten with “Hello, World!” text string piped to *stdin*.

``` javascript
chrome.action.onClicked.addListener(async _ => {
  const result = await chrome.runtime.sendNativeMessage('shell', {
    command: 'cat',
    input: 'Hello, World!',
    output: true
  })
  console.log(result.status, result.output)
})
```

Navigate back to the extension management page and click the **Reload** link.
A new field, **Inspect views**, becomes available with a blue link, **service worker**.

Click the link to view the service worker’s console log, “Hello, World!”.
