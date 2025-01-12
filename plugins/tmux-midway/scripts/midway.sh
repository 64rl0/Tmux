#!/bin/bash

#   __|    \    _ \  |      _ \   __| __ __| __ __|
#  (      _ \     /  |     (   | (_ |    |      |
# \___| _/  _\ _|_\ ____| \___/ \___|   _|     _|


CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

. "$CURRENT_DIR/helpers.sh"

mw_cookie() {
    local secs_for_expiring=900  # 20 minutes
    local now_timestamp=$(date +%s)
    local mw_cookie_text=""

    while read -r line; do
        local cookie_domain=$(echo "$line" | awk '{print $1}' | awk '{ gsub(/#HttpOnly_\.?/, ""); print }' )
        local expiry_timestamp=$(echo "$line" | awk '{print $5}')
        local cookie_name=$(echo "$line" | awk '{print $6}')

        local time_remaining_sec=$((expiry_timestamp - now_timestamp))
        local time_remaining_min=$((time_remaining_sec / 60))

        if [[ "${cookie_name}" == "amazon_enterprise_access" ]]; then
            if [[ "${cookie_domain}" =~ midway-auth.amazon.com ]]; then
                if [[ "${time_remaining_sec}" -gt "${secs_for_expiring}" ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_valid_color),bg=default]AEA ✔#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le "${secs_for_expiring}" && "${time_remaining_sec}" -gt 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expiring_color),bg=default]AEA $time_remaining_min#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expired_color),bg=default]AEA ✖#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default]"
                fi
            elif [[ "${cookie_domain}" =~ auth.midway.csphome.adc-e.uk ]]; then
                if [[ "${time_remaining_sec}" -gt "${secs_for_expiring}" ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_valid_color),bg=default]AEA-NCL ✔#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le "${secs_for_expiring}" && "${time_remaining_sec}" -gt 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expiring_color),bg=default]AEA-NCL $time_remaining_min#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expired_color),bg=default]AEA-NCL ✖#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                fi
            fi
        elif [[ "${cookie_name}" == "session" ]]; then
            if [[ "${cookie_domain}" =~ midway-auth.amazon.com ]]; then
                if [[ "${time_remaining_sec}" -gt "${secs_for_expiring}" ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_valid_color),bg=default]MW ✔#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le "${secs_for_expiring}" && "${time_remaining_sec}" -gt 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expiring_color),bg=default]MW $time_remaining_min#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expired_color),bg=default]MW ✖#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                fi
            elif [[ "${cookie_domain}" =~ auth.midway.csphome.adc-e.uk ]]; then
                if [[ "${time_remaining_sec}" -gt "${secs_for_expiring}" ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_valid_color),bg=default]MW-NCL ✔#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le "${secs_for_expiring}" && "${time_remaining_sec}" -gt 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expiring_color),bg=default]MW-NCL $time_remaining_min#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                elif [[ "${time_remaining_sec}" -le 0 ]]; then
                    mw_cookie_text+="#[fg=$(get_tmux_option @mw_cookie_expired_color),bg=default]MW-NCL ✖#[fg=$(get_tmux_option @mw_cookie_color_end),bg=default] "
                fi
            fi
        fi
    done <"${HOME}/.midway/cookie" || printf 'NOT-FOUND'

    # Remove trailing whitespace
    echo "${mw_cookie_text%"${mw_cookie_text##*[![:space:]]}"}"
}

mw_cookie

