#!/data/data/com.termux/files/usr/bin/bash

okcmd=""

usage () {
	printf "wip\n"
}

check_for_shizuku () {
	if [[ ! $(rish -c "cat /data/local/tmp/checkshizuku") == "yes" ]]; then
		am start moe.shizuku.privileged.api/moe.shizuku.manager.MainActivity > /dev/null 2>&1
		exit 1
	fi
}

get_pkgs () {
	rish -c "export PWD && /data/local/tmp/bin/bash /sdcard/src/scripts/pkgd/getpkglist.sh" | fzf -m || exit 1
}

ask_confirm () {
	local can
	printf "Do you really want to toggle $1 ? [yes|no]: "
	read -r can
	case $can in
		[Yy][Ee][Ss])
			return
			;;
		*)
			exit 1
			;;
	esac
}

toggle_pkgstate() {
	local pkgname
	local pkgstate

	while IFS='\n' read -r line
	do
		line=${line#*[}
		pkgname=${line%%]*}
		pkgstate=$(tr -d ] <<<"${line##*[}")
		case $pkgname in
			moe.shizuku.privileged.api)
				ask_confirm $pkgname
				;;
			com.termux)
				printf "lol, you thought...\n"
				exit 1
				;;
			*)
				;;
		esac
		if [[ $pkgstate == "Disabled" ]]; then
			okcmd+=$(printf "pm enable ${pkgname};")
		elif [[ $pkgstate == "Enabled" ]]; then
			okcmd+=$(printf "pm disable-user ${pkgname};")
		fi
	done <<<"$@"
	# Because calling rish for toggling pkg state will breaks the while loop for
	# some reason
	rish -c "$okcmd"
}

check_for_shizuku
toggle_pkgstate "$(get_pkgs)"
