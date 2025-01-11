#!/bin/bash

#   __|    \    _ \  |      _ \   __| __ __| __ __|
#  (      _ \     /  |     (   | (_ |    |      |
# \___| _/  _\ _|_\ ____| \___/ \___|   _|     _|

secs_for_alert=900  # 20 minutes
now_timestamp=$(date +%s)
mw_cookie_text=""

while read -r line; do
	cookie_domain=$(echo "$line" | awk '{print $1}' | awk '{ gsub(/#HttpOnly_\.?/, ""); print }' )
	expiry_timestamp=$(echo "$line" | awk '{print $5}')
	cookie_name=$(echo "$line" | awk '{print $6}')

	time_remaining_sec=$((expiry_timestamp - now_timestamp))
	time_remaining_min=$((time_remaining_sec / 60))

	if [[ "${cookie_name}" == "amazon_enterprise_access" && "${cookie_domain}" =~ midway-auth.amazon.com ]]; then
		if [[ "${time_remaining_sec}" -gt "${secs_for_alert}" ]]; then
			mw_cookie_text+="AEA ✔ "
		elif [[ "${time_remaining_sec}" -le "${secs_for_alert}" && "${time_remaining_sec}" -gt 0 ]]; then
			mw_cookie_text+="AEA $time_remaining_min "
		elif [[ "${time_remaining_sec}" -le 0 ]]; then
			mw_cookie_text+="AEA ❌ "
		fi
	elif [[ "${cookie_name}" == "session" && "${cookie_domain}" =~ midway-auth.amazon.com ]]; then
		if [[ "${time_remaining_sec}" -gt "${secs_for_alert}" ]]; then
			mw_cookie_text+="MW ✔ "
		elif [[ "${time_remaining_sec}" -le "${secs_for_alert}" && "${time_remaining_sec}" -gt 0 ]]; then
			mw_cookie_text+="MW $time_remaining_min "
		elif [[ "${time_remaining_sec}" -le 0 ]]; then
			mw_cookie_text+="MW ❌ "
		fi
	fi
done <"${HOME}/.midway/cookie" || printf 'NOT-FOUND'

# Remove trailing whitespace
printf "${mw_cookie_text%"${mw_cookie_text##*[![:space:]]}"}"

