#compdef chrome-shell

local OPTION_WORDLIST=(
  "--target=[Specifies the target platform]:platform:_chrome_shell_platforms"
  "*-v[Increases the level of verbosity (the max level is -vvv)]"
  "--log=[Specifies the file to use for logging]:file:_files"
  "-h[Show this help]"
  "--help[Show this help]"
  "-V[Show version]"
  "--version[Show version]"
)

local COMMAND_WORDLIST=(
  "run[Run server]"
  "install[Install manifest and register specified extensions]"
  "uninstall[Uninstall manifest]"
)

local PLATFORM_WORDLIST=(
  "chrome[Chrome]"
  "chrome-dev[Chrome Dev]"
  "chrome-beta[Chrome Beta]"
  "chrome-canary[Chrome Canary]"
  "chromium[Chromium]"
)

_chrome_shell_commands() {
  _values "command" "${COMMAND_WORDLIST[@]}"
}

_chrome_shell_platforms() {
  _values "platform" "${PLATFORM_WORDLIST[@]}"
}

_arguments -S -s "${OPTION_WORDLIST[@]}" "1:command:_chrome_shell_commands"
