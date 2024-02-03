#!/system/xbin/bash

argc=0
silent=0
filein=0
skiparg=0
pathout=./

for i in "$@"
do
	let "argc=argc+1"
	if [ "$skiparg" == 0 ]; then
		case "$i" in
			-s)
				silent=1
				;;
			-f)
				let "argc=argc+1"
				if [ -f "${!argc}" ]; then
					filein="${argc}"
					skiparg=1
				else
					echo "Give. me. a. goddamn file!"
					skiparg=1
				fi
				let "argc=argc-1"
				;;
			-o)
				let "argc=argc+1"
				if [ -d "${!argc}" ]; then
					if [[ $(echo "${!argc}" | grep -o '/$') == '/' ]]; then
						pathout=${!argc}
						skiparg=1
					else
						pathout=$(echo "${!argc}" | sed 's/$/\//') 
						skiparg=1
					fi
				else
					mkdir -p "${!argc}"
					if [[ $(echo "${!argc}" | grep -o '/$') == '/' ]]; then
						pathout=${!argc}
						skiparg=1
					else
						pathout=$(echo "${!argc}" | sed 's/$/\//') 
						skiparg=1
					fi
				fi
				let "argc=argc-1"
				;;
			*)
				if [ -f "${!argc}" ]; then
					filein="${argc}"
					echo "${!argc}"
				else
					echo "${!argc}"
				fi
				;;
		esac
	else
		skiparg=0
	fi
done

[ "${filein}" == 0 ] && exit 1

#songname=$(awk -F '--' '{print $1}' "${!filein}" | sed 's/\ *$//g;s/^\ *//g;s/_/\ /g')

songname=$(awk -F '--' '{print $1}' "${!filein}" \
	| sed "s/^$//g;s/\ *$//g;s/^\ *//g;s/(.*)//g")

artistname=$(awk -F '--' '{print $2}' "${!filein}" \
	| sed "s/^$//g;s/\ *$//g;s/^\ *//g")

#query=$(sed 's/^$//g;s/\ --\ /+/g;s/\ /+/g;s/_/+/g' "${!filein}")
query=$(paste -d '+' <(echo "${songname}") <(echo "${artistname}") | sed "s/(feat.)//gi;s/(.*)//g;s/feat//g;s/(//g;s/)//g;s/\ *\ /+/g;s/+*+/+/g")

while IFS='@' read -r qry song art
do
	[ "${silent}" == 0 ] && echo "Searching for "${song}"..."
	bash lrc.sh -s! "${qry}" > "${pathout}${song} - ${art}.lrc"
	[ "${silent}" == 0 ] && echo "Done."
done <<<"$(paste -d '@' <(echo "${query}") <(echo "${songname}") <(echo "${artistname}"))"

exit 0
