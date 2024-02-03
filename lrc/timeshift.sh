#!/system/xbin/bash

#TODO: This is bullshit. Rewrite everthing!
shopt -s extglob

lrc_path="/sdcard/RetroMusic/lyrics"
argc=0
intend=0
silent=0
offin=""
okay=0
filein=""

for i in "$@"
do
	let "argc=argc+1"
	case $i in
		-s)
			silent=1
			;;
		-i)
			intend=1
			;;
		?([0-9]*)?(.)[0-9]*)
			okay=1
			;;
		[*+-])
			okay=1
			;;
		[*+-]?([0-9]*)?(.)[0-9]*)
			offin="${!argc}"
			;;
		*)
			if [[ -f $i ]]; then
				filein="${!argc}"
			fi
			;;
	esac
done

get_offin(){
	printf "Type the operator and value [*+-][offset in seconds] : "
	read -r offin
}

get_file() {
	filein=$(find "$lrc_path" -iname *.lrc | fzf)
	[ -z "$filein" ] && exit 1
}

[ -z "$filein" ] && get_file
#[ -z "$filein" ] && echo "Give. me. a. goddamn file!" && exit 1

calc_offset() {
	opr=$(grep -o "^." <<<"$offin")
	offset=$(sed 's/\n//g;s/[+-]//' <<<"$offin")
	while [[ -z $opr || -z $offset ]]
	do
		get_offin
		opr=$(grep -o "^." <<<"$offin")
		offset=$(sed 's/\n//g;s/[+-]//' <<<"$offin")
	done

	if [[ $(grep -o "\-\-\-" "${filein}") ]]; then
		curated=$(sed -n "/---/,/---/{/---/!p}" "${filein}" | grep "\[[0-9].\{6\}[0-9]\]")
	else
		curated=$(grep "\[[0-9].\{6\}[0-9]\]" "${filein}")
	fi

	if ([ ! -z "${filein}" ] && [ "${okay}" == 0 ]); then
		if [[ ${opr} == "+" ]]; then
			[ ${silent} = 0 ] && echo "Calculating increment..."
			old=$(echo "${curated}" | grep -o "\[........\]")
			changed=$(echo "${curated}" | grep -o "\[........\]" | grep -o [0-9]......[0-9] | awk -F ':' -v off="$offset" '{print (($1 * 60) + $2) + off}')
		elif [[ ${opr} == "-" ]]; then
			[ ${silent} = 0 ] && echo "Calculating decrement..."
			old=$(echo "${curated}" | grep -o "\[........\]")
			changed=$(echo "${curated}" | grep -o "\[........\]" | grep -o [0-9]......[0-9] | awk -F ':' -v off="$offset" '{print (($1 * 60) + $2) - off}')
		elif [[ ${opr} == "*" ]]; then
			[ ${silent} = 0 ] && echo "Doing something..."
			old=$(echo "${curated}" | grep -o "\[........\]")
			changed=$(echo "${curated}" | grep -o "\[........\]" | grep -o [0-9]......[0-9] | awk -F ':' -v off="$offset" '{print (($1 * 60) + $2) * off}')
		else 
			echo "Kindly specify an operator, stranger. [+-*]" && [ "${okay}" == 0 ] && echo "And a value too..."
			exit 1
		fi
	else
		[ "${silent}" == 0 ] && echo "How the turntables..."
		cat "${filein}"
		exit 0
	fi
}

update_lrc() {
	new=$(awk '{printf "[" "%.2d" ":" "%05.2f" "]\n", int($1/60), $1%60}' <<<"${changed}")
	[ ${silent} = 0 ] && echo "applying offset..."
	if [ $intend == 0 ]; then
		content=$(cat "${filein}")
		while read -r i j
		do
			content="$(sed "0,/"$i"/{s/"$i"/"$j"/}" <<<"${content}")" 
		done <<<"$(sed 's/\[//g;s/\]//g' <(paste <(echo "$old") <(echo "$new")))"
	else
		while read -r i j
		do
			sed -i "s/"$i"/"$j"/" "${filein}"
		done <<<"$(paste <(echo "$old") <(echo "$new") | sed 's/\[//g;s/\]//g')"
	fi
}

calc_offset
update_lrc

[ ${silent} = 0 ] && echo "done."
[ ${intend} = 0 ] && echo "$content"

exit
