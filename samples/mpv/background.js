const port = chrome.runtime.connectNative('shell')

chrome.action.onClicked.addListener((tab) => {
  port.postMessage({
    command: 'mpv',
    args: [tab.url]
  })
})
