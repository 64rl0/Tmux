#!/usr/bin/env bash

#   __|    \    _ \  |      _ \   __| __ __| __ __|
#  (      _ \     /  |     (   | (_ |    |      |
# \___| _/  _\ _|_\ ____| \___/ \___|   _|     _|


CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "$CURRENT_DIR/scripts/helpers.sh"

mw_interpolation="\#{mw_cookie}"
# Execute the script, check if it contains N/A or is blank.
# If it does, return an empty string. If it contains a real cookie, expand the module.
mw_command="#(?{m:*N/A*,#(${CURRENT_DIR}/scripts/midway.sh)},,#(${CURRENT_DIR}/scripts/midway.sh))"

set_tmux_option() {
  local option=$1
  local value=$2
  tmux set-option -gq "$option" "$value"
}

do_interpolation() {
  local all_interpolated="$1"
  all_interpolated=${all_interpolated//${mw_interpolation}/${mw_command}}
  echo "$all_interpolated"
}

update_tmux_option() {
  local option
  local option_value
  local new_option_value
  option=$1
  option_value=$(get_tmux_option "$option")
  new_option_value=$(do_interpolation "$option_value")
  set_tmux_option "$option" "$new_option_value"
}

main() {
  update_tmux_option "status-right"
  update_tmux_option "status-left"
}

main

