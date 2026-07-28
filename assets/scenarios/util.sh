#!/usr/bin/env bash

# Ensure UTF-8 locale for correct character width calculation
export LANG=${LANG:-C.UTF-8}


TYPE_SPEED=100

# Helper to print a message in a frame
_print_frame() {
  local lines=()
  local max_len=0
  local arg line len i border padding

  # Collect all lines from all arguments
  for arg in "$@"; do
    while IFS= read -r line; do
      lines+=("$line")
      len=$(printf "%s" "$line" | wc -L)
      (( len > max_len )) && max_len=$len
    done <<< "$arg"
  done

  [[ ${#lines[@]} -eq 0 ]] && return

  border=""
  for ((i=0; i<max_len+2; i++)); do border+="─"; done

  echo ""
  printf '┌%s┐\n' "$border"
  for line in "${lines[@]}"; do
    len=$(printf "%s" "$line" | wc -L)
    padding=$((max_len - len))
    printf '│ %s%*s │\n' "$line" "$padding" ""
  done
  printf '└%s┘\n' "$border"
}

# Internal helper to handle icons and indentation
_log_with_icon() {
  local icon="$1 "
  shift
  [[ $# -eq 0 ]] && return
  
  local first=true
  local processed_lines=()
  local width=$(printf "%s" "$icon" | wc -L)
  local indent=$(printf "%${width}s" "")
  local arg line

  for arg in "$@"; do
    while IFS= read -r line; do
      if $first; then
        processed_lines+=("$icon$line")
        first=false
      else
        processed_lines+=("$indent$line")
      fi
    done <<< "$arg"
  done
  _print_frame "${processed_lines[@]}"
}

comment() {
  _log_with_icon "✨" "$@"
}

redirect() {
  _log_with_icon "📺" "$@"
}

info() {
  _log_with_icon "💡" "$@"
}

error() {
  _log_with_icon "🚨" "$@"
}

# pe_as <display_cmd> <actual_cmd>
# Prints the first command but executes the second.
pe_as() {
  p "$1"
  run_cmd "$2"
}

# Wait for the user to type "go"
cont() {
  local input=""
  until [[ "$input" == "go" ]]; do
    read -p 'Type "go" to continue: ' input
  done
}

PROMPT_NS1="\[\e[30;42m\][ns1]$ \[\e[0m\] "
PROMPT_NODE="\[\e[37;44m\][node]$ \[\e[0m\] "
PROMPT_NS2="\[\e[37;41m\][ns2]$ \[\e[0m\] "

PROMPT_NODE1="\[\e[37;44m\][node1]$ \[\e[0m\] "
PROMPT_NODE1_POD1="\[\e[30;42m\][pod1@node1]$ \[\e[0m\] "
PROMPT_NODE2="\[\e[37;45m\][node2]$ \[\e[0m\] "
PROMPT_NODE2_POD2="\[\e[37;41m\][pod2@node2]$ \[\e[0m\] "
