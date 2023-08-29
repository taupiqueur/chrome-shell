_chrome_shell() {
  local IFS='
'
  local OPTION_WORDLIST=(
    "--target="
    "-h "
    "--help "
    "-v "
    "--version "
  )
  local COMMAND_WORDLIST=(
    "run "
    "install "
    "uninstall "
  )
  local PLATFORM_WORDLIST=(
    "chrome "
    "chrome-dev "
    "chrome-beta "
    "chrome-canary "
    "chromium "
  )
  local command=chrome_shell
  for word in "${COMP_WORDS[@]:1:COMP_CWORD}"
  do
    case "$command,$word" in
      chrome_shell,run)
        command=chrome_shell_run
        break
        ;;
      chrome_shell,install)
        command=chrome_shell_install
        break
        ;;
      chrome_shell,uninstall)
        command=chrome_shell_uninstall
        break
        ;;
    esac
  done
  COMPREPLY=(
    $(
      case "$command,$3,$2" in
        chrome_shell,--target,*)
          compgen -W "${PLATFORM_WORDLIST[*]}" -- "$2"
          ;;
        chrome_shell,*,-*)
          compgen -W "${OPTION_WORDLIST[*]}" -- "$2"
          ;;
        chrome_shell,*,*)
          compgen -W "${COMMAND_WORDLIST[*]}" -- "$2"
          ;;

        chrome_shell_run,--target,*)
          compgen -W "${PLATFORM_WORDLIST[*]}" -- "$2"
          ;;
        chrome_shell_run,*,-*)
          compgen -W "${OPTION_WORDLIST[*]}" -- "$2"
          ;;

        chrome_shell_install,--target,*)
          compgen -W "${PLATFORM_WORDLIST[*]}" -- "$2"
          ;;
        chrome_shell_install,*,-*)
          compgen -W "${OPTION_WORDLIST[*]}" -- "$2"
          ;;

        chrome_shell_uninstall,--target,*)
          compgen -W "${PLATFORM_WORDLIST[*]}" -- "$2"
          ;;
        chrome_shell_uninstall,*,-*)
          compgen -W "${OPTION_WORDLIST[*]}" -- "$2"
          ;;
      esac
    )
  )
}

complete -o bashdefault -o default -o nospace -F _chrome_shell chrome-shell
