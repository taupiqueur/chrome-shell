def "nu-complete chrome-shell subcommands" [] {
  [
    ["value", "description"];
    ["run", "Run server"],
    ["install", "Install manifest and register specified extensions"],
    ["uninstall", "Uninstall manifest"],
  ]
}

def "nu-complete chrome-shell platforms" [] {
  [
    ["value", "description"];
    ["chrome", "Chrome"],
    ["chrome-dev", "Chrome Dev"],
    ["chrome-beta", "Chrome Beta"],
    ["chrome-canary", "Chrome Canary"],
    ["chromium", "Chromium"],
  ]
}

# A native messaging host for executing shell commands.
extern "chrome-shell" [
  command: string@"nu-complete chrome-shell subcommands" = "run" # The command to run
  --target: string@"nu-complete chrome-shell platforms" = "chrome" # Specifies the target platform. Possible values: [`chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary`, `chromium`]
  -v # Increases the level of verbosity (the max level is `-vvv`)
  --log: path = "/dev/stderr" # Specifies the file to use for logging
  --help(-h) # Show this help
  --version(-V) # Show version
]

# Run server
extern "chrome-shell run" [
  --target: string@"nu-complete chrome-shell platforms" = "chrome" # Specifies the target platform. Possible values: [`chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary`, `chromium`]
  -v # Increases the level of verbosity (the max level is `-vvv`)
  --log: path = "/dev/stderr" # Specifies the file to use for logging
  --help(-h) # Show this help
  --version(-V) # Show version
]

# Install manifest and register specified extensions
extern "chrome-shell install" [
  ...extension_ids: string # The list of extension IDs to register
  --target: string@"nu-complete chrome-shell platforms" = "chrome" # Specifies the target platform. Possible values: [`chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary`, `chromium`]
  -v # Increases the level of verbosity (the max level is `-vvv`)
  --log: path = "/dev/stderr" # Specifies the file to use for logging
  --help(-h) # Show this help
  --version(-V) # Show version
]

# Uninstall manifest
extern "chrome-shell uninstall" [
  --target: string@"nu-complete chrome-shell platforms" = "chrome" # Specifies the target platform. Possible values: [`chrome`, `chrome-dev`, `chrome-beta`, `chrome-canary`, `chromium`]
  -v # Increases the level of verbosity (the max level is `-vvv`)
  --log: path = "/dev/stderr" # Specifies the file to use for logging
  --help(-h) # Show this help
  --version(-V) # Show version
]
