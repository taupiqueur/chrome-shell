chrome.action.onClicked.addListener(async _ => {
  const tabs = await chrome.tabs.query({})
  const menu = new Map(
    tabs.map((tab, index) => [
      `${index} ${tab.title} ${tab.url}`, tab
    ])
  )
  const input = Array.from(menu.keys()).join('\n')
  const result = await chrome.runtime.sendNativeMessage('shell', {
    command: 'dmenu',
    args: [],
    input,
    output: true
  })
  const [choice] = result.output.split('\n')
  if (menu.has(choice)) {
    const tab = menu.get(choice)
    await chrome.tabs.update(tab.id, { active: true })
    await chrome.windows.update(tab.windowId, { focused: true })
  }
})
