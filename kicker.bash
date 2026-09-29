# bash completion for kicker
_kicker() {
  local cur prev commands apps
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  commands="start stop restart status list log launchd help"

  if [[ $COMP_CWORD -eq 1 ]]; then
    COMPREPLY=($(compgen -W "$commands" -- "$cur"))
    return
  fi

  case "${COMP_WORDS[1]}" in
    start|stop|restart|status)
      apps="all $(kicker list 2>/dev/null | awk '{print $1}')"
      COMPREPLY=($(compgen -W "$apps" -- "$cur"))
      ;;
    log|logs)
      if [[ "$prev" == "-n" || "$prev" == "--lines" ]]; then
        return
      fi
      apps="all -f -n $(kicker list 2>/dev/null | awk '{print $1}')"
      COMPREPLY=($(compgen -W "$apps" -- "$cur"))
      ;;
    launchd)
      [[ $COMP_CWORD -eq 2 ]] && COMPREPLY=($(compgen -W "install uninstall" -- "$cur"))
      ;;
  esac
}
complete -F _kicker kicker
