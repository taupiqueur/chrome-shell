set edit:completion:arg-completer["chrome-shell"] = { |command @args|
  edit:complete-getopt $args [
    [
      &long="target"
      &desc="Specifies the target platform"
      &arg-required
      &completer={ |arg|
        edit:complex-candidate "chrome" &display="chrome (Chrome)"
        edit:complex-candidate "chrome-dev" &display="chrome-dev (Chrome Dev)"
        edit:complex-candidate "chrome-beta" &display="chrome-beta (Chrome Beta)"
        edit:complex-candidate "chrome-canary" &display="chrome-canary (Chrome Canary)"
        edit:complex-candidate "chromium" &display="chromium (Chromium)"
      }
    ]
    [
      &short="v"
      &desc="Increases the level of verbosity (the max level is -vvv)"
    ]
    [
      &long="log"
      &desc="Specifies the file to use for logging"
      &arg-required
      &completer={ |arg|
        edit:complete-filename $arg
      }
    ]
    [
      &short="h"
      &long="help"
      &desc="Show this help"
    ]
    [
      &short="V"
      &long="version"
      &desc="Show version"
    ]
  ] [
    { |arg|
      edit:complex-candidate "run" &display="run (Run server)"
      edit:complex-candidate "install" &display="install (Install manifest and register specified extensions)"
      edit:complex-candidate "uninstall" &display="uninstall (Uninstall manifest)"
    }
  ]
}
