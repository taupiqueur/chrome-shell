chrome.action.onClicked.addListener(async _ => {
  const result = await chrome.runtime.sendNativeMessage('shell', {
    command: 'echo',
    args: ['Hello, World!'],
    output: true
  })
  console.log(result.status, result.output)
})
