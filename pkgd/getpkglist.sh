#!/data/local/tmp/bin/bash

pkg_info=""
pkgd_dir="/sdcard/pkgdisabler"
pkgd_tmp_dir="${pkgd_dir}/tmp"
pkg_listf="${pkgd_dir}/pkglist"
pkg_list=""
pkg_labeled_list=""

write_pkglist() {
	printf "$pkg_list" | sed '/^$/d' | sort -t "@" -k3 > $pkg_listf
}

get_pkglabel() {
	local pkgpath
	local pkgname
	local pkglabel
	local pkgstate

	for line in "$@"
	do
		pkgpath=${line%%@*}
		# there must be a better way.
		pkgname=${line#*@}
		pkgname=${pkgname%@*}
		pkgstate=${line##*@}
		pkglabel=$(/data/local/tmp/bin/aapt dump badging "$pkgpath" | grep -i "application: label" | cut -d"'" -f2)
		[[ -z $pkglabel ]] && pkglabel="No Label"
		pkg_info+="$pkglabel@$pkgpath@$pkgname@$pkgstate\n"
	done
}

get_pkglabel_from_file () {
	local pkgpath
	local pkgname
	local pkglabel
	local pkgstate
	local got_nothing=""

	for line in "$@"
	do
		pkgpath=${line%%@*}
		# there must be a better way.
		pkgname=${line#*@}
		pkgname=${pkgname%@*}
		pkgstate=${line##*@}
		pkglabel=$(grep "$pkgname" $pkg_listf | cut -d "@" -f1)
		if [[ -z $pkglabel ]]; then
			got_nothing+="$pkgpath@$pkgname@$pkgstate\n"
		else
			pkg_info+="$pkglabel@$pkgpath@$pkgname@$pkgstate\n"
		fi
	done

	get_pkglabel $got_nothing
}

rm_non_pkgs() {
	for line in "$@"
	do
		pkg_list=$(sed "s%^.*$line.*$%%" <<<"$pkg_list")
	done
	pkg_list=$(sed "/^$/d" <<<"$pkg_list")
}

get_nonlabeledpkgs() {
	local cur_pkglist
	local diffed
	local need_to_add
	local need_to_rm
	if [[ -f $pkg_listf ]]; then
		pkg_list=$(cat $pkg_listf)
		cur_pkglist=$(pm list packages -d -f | sed 's/^package://;s/\(.*\)=/\1@/;s/$/@Disabled/';pm list packages -e -f | sed 's/^package://;s/\(.*\)=/\1@/;s/$/@Enabled/')

		sort -t "@" -k2 <<<"$cur_pkglist" > ${pkgd_tmp_dir}/cur 
		awk -F "@" '{print $2 "@" $3 "@" $4}' "$pkg_listf" | sort -t "@" -k2 > ${pkgd_tmp_dir}/old
		#fuck diff, there is no flag to change the /tmp dir.
		#Maybe fuck Android...
		diffed=$(diff -u ${pkgd_tmp_dir}/old ${pkgd_tmp_dir}/cur | grep "^[-+]/.*")

		need_to_add="$(grep "^+" <<<"$diffed" | sed 's/^+//')"
		need_to_rm="$(grep "^-" <<<"$diffed" | sed 's/^-//')"

		[[ -z $need_to_add ]] || get_pkglabel_from_file $need_to_add
		[[ -z $need_to_rm ]] || rm_non_pkgs $need_to_rm

	else
		get_pkglabel $(pm list packages -d -f | sed "s/^package://s/.apk=/.apk@/;s/$/@Disabled/")
		get_pkglabel $(pm list packages -e -f | sed "s/^package://s/.apk=/.apk@/;s/$/@Enabled/")
	fi

	pkg_list+="\n$pkg_info"
	printf -- "$pkg_list" | awk -F "@" '{print $1 " --> [" $3 "] [" $4 "]"}'
}

get_nonlabeledpkgs
write_pkglist
