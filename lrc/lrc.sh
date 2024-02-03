#!/system/xbin/bash

argc=0
silent=0
qryin=0
skiparg=0
headnumb=1
tailnumb=1
count=1
rent=0
pathout=./

usage() {
	printf 'usage: lrc.sh [-s for silent] [-s! for silent!] [-r to query rentad]\n'
	printf '              [-n number] [-c count] [-o output path *wip*] [query]\n'
	exit 1
}

[ "${#@}" == 0 ] && usage

for i in "$@"
do
	if [ "${skiparg}" == 0 ]; then
		let "argc=argc+1"
		case "$i" in
			-s)
				silent=1
				;;
			-s!)
				silent=2
				;;
			-r)
				rent=1
				;;
			-h)
				usage
				;;
			-n)
				let "argc=argc+1"
				headnumb="${!argc}"
				let "argc=argc-1"
				skiparg=1
				;;
			-c)
				let "argc=argc+1"
				count="${!argc}"
				let "argc=argc-1"
				skiparg=1
				;;
			-o)
				let "argc=argc+1"
				[ -d "${!argc}" ] || mkdir -p "${!argc}"
				if [[ $(grep -o "/$" <<<"${!argc}") == "/" ]]; then
					pathout="${!argc}"
					skiparg=1
				else
					pathout=$(sed 's/$/\//g' <<<"${!argc}")
					skiparg=1
				fi
				let "argc=argc-1"
				;;
			*)
				qryin="${argc}"
				;;
		esac
	else
		skiparg=0
	fi
done


if [ "${count}" -gt 1 ]; then
	headnumb="${count}"
	tailnumb="${count}"
fi

curate () {
	sed \
		-e "s/&#32\;/ /g;s/&#9702\;/◦/g;s/&#8729\;/∙/g" \
		-e "s/&#8227\;/‣/g;s/&#8259\;/⁃/g;s/&#33\;/!/g" \
		-e "s/&#35\;/#/g;s/&#36\;/$/g;s/&#37\;/%/g" \
		-e "s/&#40\;/(/g;s/&#41\;/)/g;s/&#42\;/*/g" \
		-e "s/&#43\;/+/g;s/&#44\;/,/g;s/&#45\;/-/g" \
		-e "s/&#46\;/./g;s/&#47\;/\//g;s/&#48\;/0/g" \
		-e "s/&#49\;/1/g;s/&#50\;/2/g;s/&#51\;/3/g" \
		-e "s/&#52\;/4/g;s/&#53\;/5/g;s/&#54\;/6/g" \
		-e "s/&#55\;/7/g;s/&#56\;/8/g;s/&#57\;/9/g" \
		-e "s/&#58\;/:/g;s/&#59\;/;/g;s/&#61\;/=/g" \
		-e "s/&#63\;/?/g;s/&#64\;/@/g;s/&#65\;/A/g" \
		-e "s/&#66\;/B/g;s/&#67\;/C/g;s/&#68\;/D/g" \
		-e "s/&#69\;/E/g;s/&#70\;/F/g;s/&#71\;/G/g" \
		-e "s/&#72\;/H/g;s/&#73\;/I/g;s/&#74\;/J/g" \
		-e "s/&#75\;/K/g;s/&#76\;/L/g;s/&#77\;/M/g" \
		-e "s/&#78\;/N/g;s/&#79\;/O/g;s/&#80\;/P/g" \
		-e "s/&#81\;/Q/g;s/&#82\;/R/g;s/&#83\;/S/g" \
		-e "s/&#84\;/T/g;s/&#85\;/U/g;s/&#86\;/V/g" \
		-e "s/&#87\;/W/g;s/&#88\;/X/g;s/&#89\;/Y/g" \
		-e "s/&#90\;/Z/g;s/&#91\;/[/g;s/&#92\;/\\\/g" \
		-e "s/&#93\;/]/g;s/&#94\;/^/g;s/&#95\;/_/g" \
		-e "s/&#96\;/\`/g;s/&#97\;/a/g;s/&#98\;/b/g" \
		-e "s/&#99\;/c/g;s/&#100\;/d/g;s/&#101\;/e/g" \
		-e "s/&#102\;/f/g;s/&#103\;/g/g;s/&#104\;/h/g" \
		-e "s/&#105\;/i/g;s/&#106\;/j/g;s/&#107\;/k/g" \
		-e "s/&#108\;/l/g;s/&#109\;/m/g;s/&#110\;/n/g" \
		-e "s/&#111\;/o/g;s/&#112\;/p/g;s/&#113\;/q/g" \
		-e "s/&#114\;/r/g;s/&#115\;/s/g;s/&#116\;/t/g" \
		-e "s/&#117\;/u/g;s/&#118\;/v/g;s/&#119\;/w/g" \
		-e "s/&#120\;/x/g;s/&#121\;/y/g;s/&#122\;/z/g" \
		-e "s/&#123\;/{/g;s/&#8377\;/₹/g;s/&#36\;/$/g" \
		-e "s/&#8360\;/₨/g;s/&#8369\;/₱/g;s/&#8361\;/₩/g" \
		-e "s/&#3647\;/฿/g;s/&#8363\;/₫/g;s/&#8362\;/₪/g" \
		-e "s/&#8480\;/℠/g;s/&#8471\;/℗/g;s/&#124\;/|/g" \
		-e "s/&#125\;/}/g;s/&#126\;/~/g;s/&#160\;/ /g" \
		-e "s/&nbsp\;/ /g;s/&#34\;/\"/g;s/&quot\;/\"/g" \
		-e "s/&#161\;/¡/g;s/&iexcl\;/¡/g;s/&#162\;/¢/g" \
		-e "s/&cent\;/¢/g;s/&#38\;/&/g;s/&amp\;/&/g" \
		-e "s/&#39\;/'/g;s/&apos\;/'/g;s/&#163\;/£/g" \
		-e "s/&pound\;/£/g;s/&#60\;/</g;s/&lt\;/</g" \
		-e "s/&#62\;/>/g;s/&gt\;/>/g;s/&#164\;/¤/g" \
		-e "s/&curren\;/¤/g;s/&#165\;/¥/g;s/&yen\;/¥/g" \
		-e "s/&#166\;/¦/g;s/&brvbar\;/¦/g;s/&#167\;/§/g" \
		-e "s/&sect\;/§/g;s/&#168\;/¨/g;s/&uml\;/¨/g" \
		-e "s/&#169\;/©/g;s/&copy\;/©/g;s/&#170\;/ª/g" \
		-e "s/&ordf\;/ª/g;s/&#171\;/«/g;s/&laquo\;/«/g" \
		-e "s/&#172\;/¬/g;s/&not\;/¬/g;s/&#173\;/­/g" \
		-e "s/&shy\;/­/g;s/&#174\;/®/g;s/&reg\;/®/g" \
		-e "s/&#175\;/¯/g;s/&macr\;/¯/g;s/&#176\;/°/g" \
		-e "s/&deg\;/°/g;s/&#177\;/±/g;s/&plusmn\;/±/g" \
		-e "s/&#178\;/²/g;s/&sup2\;/²/g;s/&#179\;/³/g" \
		-e "s/&sup3\;/³/g;s/&#180\;/´/g;s/&acute\;/´/g" \
		-e "s/&#181\;/µ/g;s/&micro\;/µ/g;s/&#182\;/¶/g" \
		-e "s/&para\;/¶/g;s/&#183\;/·/g;s/&middot\;/·/g" \
		-e "s/&#184\;/¸/g;s/&cedil\;/¸/g;s/&#185\;/¹/g" \
		-e "s/&sup1\;/¹/g;s/&#186\;/º/g;s/&ordm\;/º/g" \
		-e "s/&#187\;/»/g;s/&raquo\;/»/g;s/&#188\;/¼/g" \
		-e "s/&frac14\;/¼/g;s/&#189\;/½/g;s/&frac12\;/½/g" \
		-e "s/&#190\;/¾/g;s/&frac34\;/¾/g;s/&#191\;/¿/g" \
		-e "s/&iquest\;/¿/g;s/&#192\;/À/g;s/&Agrave\;/À/g" \
		-e "s/&#193\;/Á/g;s/&Aacute\;/Á/g;s/&#194\;/Â/g" \
		-e "s/&Acirc\;/Â/g;s/&#195\;/Ã/g;s/&Atilde\;/Ã/g" \
		-e "s/&#196\;/Ä/g;s/&Auml\;/Ä/g;s/&#197\;/Å/g" \
		-e "s/&Aring\;/Å/g;s/&#198\;/Æ/g;s/&AElig\;/Æ/g" \
		-e "s/&#199\;/Ç/g;s/&Ccedil\;/Ç/g;s/&#200\;/È/g" \
		-e "s/&Egrave\;/È/g;s/&#201\;/É/g;s/&Eacute\;/É/g" \
		-e "s/&#202\;/Ê/g;s/&Ecirc\;/Ê/g;s/&#203\;/Ë/g" \
		-e "s/&Euml\;/Ë/g;s/&#204\;/Ì/g;s/&Igrave\;/Ì/g" \
		-e "s/&#205\;/Í/g;s/&Iacute\;/Í/g;s/&#206\;/Î/g" \
		-e "s/&Icirc\;/Î/g;s/&#207\;/Ï/g;s/&Iuml\;/Ï/g" \
		-e "s/&#208\;/Ð/g;s/&ETH\;/Ð/g;s/&#209\;/Ñ/g" \
		-e "s/&Ntilde\;/Ñ/g;s/&#210\;/Ò/g;s/&Ograve\;/Ò/g" \
		-e "s/&#211\;/Ó/g;s/&Oacute\;/Ó/g;s/&#212\;/Ô/g" \
		-e "s/&Ocirc\;/Ô/g;s/&#213\;/Õ/g;s/&Otilde\;/Õ/g" \
		-e "s/&#214\;/Ö/g;s/&Ouml\;/Ö/g;s/&#215\;/×/g" \
		-e "s/&times\;/×/g;s/&#216\;/Ø/g;s/&Oslash\;/Ø/g" \
		-e "s/&#217\;/Ù/g;s/&Ugrave\;/Ù/g;s/&#218\;/Ú/g" \
		-e "s/&Uacute\;/Ú/g;s/&#219\;/Û/g;s/&Ucirc\;/Û/g" \
		-e "s/&#220\;/Ü/g;s/&Uuml\;/Ü/g;s/&#221\;/Ý/g" \
		-e "s/&Yacute\;/Ý/g;s/&#222\;/Þ/g;s/&THORN\;/Þ/g" \
		-e "s/&#223\;/ß/g;s/&szlig\;/ß/g;s/&#224\;/à/g" \
		-e "s/&agrave\;/à/g;s/&#225\;/á/g;s/&aacute\;/á/g" \
		-e "s/&#226;/â/g;s/&\;/â/g;s/&#227\;/ã/g" \
		-e "s/&atilde\;/ã/g;s/&#228\;/ä/g;s/&auml\;/ä/g" \
		-e "s/&#229\;/å/g;s/&aring\;/å/g;s/&#230\;/æ/g" \
		-e "s/&aelig\;/æ/g;s/&#231\;/ç/g;s/&ccedil\;/ç/g" \
		-e "s/&#232\;/è/g;s/&egrave\;/è/g;s/&#233\;/é/g" \
		-e "s/&eacute\;/é/g;s/&#234\;/ê/g;s/&ecirc\;/ê/g" \
		-e "s/&#235\;/ë/g;s/&euml\;/ë/g;s/&#236\;/ì/g" \
		-e "s/&igrave\;/ì/g;s/&#237\;/í/g;s/&iacute\;/í/g" \
		-e "s/&#238\;/î/g;s/&icirc\;/î/g;s/&#239\;/ï/g" \
		-e "s/&iuml\;/ï/g;s/&#240\;/ð/g;s/&eth\;/ð/g" \
		-e "s/&#241\;/ñ/g;s/&ntilde\;/ñ/g;s/&#242\;/ò/g" \
		-e "s/&ograve\;/ò/g;s/&#243\;/ó/g;s/&oacute\;/ó/g" \
		-e "s/&#244\;/ô/g;s/&ocirc\;/ô/g;s/&#245\;/õ/g" \
		-e "s/&otilde\;/õ/g;s/&#246\;/ö/g;s/&ouml\;/ö/g" \
		-e "s/&#247\;/÷/g;s/&divide\;/÷/g;s/&#248\;/ø/g" \
		-e "s/&oslash\;/ø/g;s/&#249\;/ù/g;s/&ugrave\;/ù/g" \
		-e "s/&#250\;/ú/g;s/&uacute\;/ú/g;s/&#251\;/û/g" \
		-e "s/&ucirc\;/û/g;s/&#252\;/ü/g;s/&uuml\;/ü/g" \
		-e "s/&#253\;/ý/g;s/&yacute\;/ý/g;s/&#254\;/þ/g" \
		-e "s/&thorn\;/þ/g;s/&#255\;/ÿ/g;s/&yuml\;/ÿ/g" \
		-e "s/&#38\;/&/g;s/&amp\;/&/g;s/&#8226\;/•/g" \
		-e "s/&bull\;/•/g;s/&#176\;/°/g;s/&deg\;/°/g" \
		-e "s/&#8734\;/∞/g;s/&infin\;/∞/g;s/&#8240\;/‰/g" \
		-e "s/&permil\;/‰/g;s/&#8901\;/⋅/g;s/&sdot\;/⋅/g" \
		-e "s/&#177\;/±/g;s/&plusmn\;/±/g;s/&#8224\;/†/g" \
		-e "s/&dagger\;/†/g;s/&#8212\;/—/g;s/&mdash\;/—/g" \
		-e "s/&#172\;/¬/g;s/&not\;/¬/g;s/&#181\;/µ/g" \
		-e "s/&micro\;/µ/g;s/&#8869\;/⊥/g;s/&perp\;/⊥/g" \
		-e "s/&#8741\;/∥/g;s/&par\;/∥/g;s/&#8364\;/€/g" \
		-e "s/&euro\;/€/g;s/&#163\;/£/g;s/&pound\;/£/g" \
		-e "s/&#165\;/¥/g;s/&yen\;/¥/g;s/&#162\;/¢/g" \
		-e "s/&cent\;/¢/g;s/&#169\;/©/g;s/&copy\;/©/g" \
		-e "s/&#174\;/®/g;s/&reg\;/®/g;s/&#8482\;/™/g" \
		-e "s/&trade\;/™/g;s/&#945\;/α/g;s/&alpha\;/α/g" \
		-e "s/&#946\;/β/g;s/&beta\;/β/g;s/&#947\;/γ/g" \
		-e "s/&gamma\;/γ/g;s/&#948\;/δ/g;s/&delta\;/δ/g" \
		-e "s/&#949\;/ε/g;s/&epsilon\;/ε/g;s/&#950\;/ζ/g" \
		-e "s/&zeta\;/ζ/g;s/&#951\;/η/g;s/&eta\;/η/g" \
		-e "s/&#952\;/θ/g;s/&theta\;/θ/g;s/&#953\;/ι/g" \
		-e "s/&iota\;/ι/g;s/&#954\;/κ/g;s/&kappa\;/κ/g" \
		-e "s/&#955\;/λ/g;s/&lambda\;/λ/g;s/&#956\;/μ/g" \
		-e "s/&mu\;/μ/g;s/&#957\;/ν/g;s/&nu\;/ν/g" \
		-e "s/&#958\;/ξ/g;s/&xi\;/ξ/g;s/&#959\;/ο/g" \
		-e "s/&omicron\;/ο/g;s/&#960\;/π/g;s/&pi\;/π/g" \
		-e "s/&#961\;/ρ/g;s/&rho\;/ρ/g;s/&#963\;/σ/g" \
		-e "s/&sigma\;/σ/g;s/&#964\;/τ/g;s/&tau\;/τ/g" \
		-e "s/&#965\;/υ/g;s/&upsilon\;/υ/g;s/&#966\;/φ/g" \
		-e "s/&phi\;/φ/g;s/&#967\;/χ/g;s/&chi\;/χ/g" \
		-e "s/&#968\;/ψ/g;s/&psi\;/ψ/g;s/&#969\;/ω/g" \
		-e "s/&omega\;/ω/g;s/&#913\;/Α/g;s/&Alpha\;/Α/g" \
		-e "s/&#914\;/Β/g;s/&Beta\;/Β/g;s/&#915\;/Γ/g" \
		-e "s/&Gamma\;/Γ/g;s/&#916\;/Δ/g;s/&Delta\;/Δ/g" \
		-e "s/&#917\;/Ε/g;s/&Epsilon\;/Ε/g;s/&#918\;/Ζ/g" \
		-e "s/&Zeta\;/Ζ/g;s/&#919\;/Η/g;s/&Eta\;/Η/g" \
		-e "s/&#920\;/Θ/g;s/&Theta\;/Θ/g;s/&#921\;/Ι/g" \
		-e "s/&Iota\;/Ι/g;s/&#922\;/Κ/g;s/&Kappa\;/Κ/g" \
		-e "s/&#923\;/Λ/g;s/&Lambda\;/Λ/g;s/&#924\;/Μ/g" \
		-e "s/&Mu\;/Μ/g;s/&#925\;/Ν/g;s/&Nu\;/Ν/g" \
		-e "s/&#926\;/Ξ/g;s/&Xi\;/Ξ/g;s/&#927\;/Ο/g" \
		-e "s/&Omicron\;/Ο/g;s/&#928\;/Π/g;s/&Pi\;/Π/g" \
		-e "s/&#929\;/Ρ/g;s/&Rho\;/Ρ/g;s/&#931\;/Σ/g" \
		-e "s/&Sigma\;/Σ/g;s/&#932\;/Τ/g;s/&Tau\;/Τ/g" \
		-e "s/&#933\;/Υ/g;s/&Upsilon\;/Υ/g;s/&#934\;/Φ/g" \
		-e "s/&Phi\;/Φ/g;s/&#935\;/Χ/g;s/&Chi\;/Χ/g" \
		-e "s/&#936\;/Ψ/g;s/&Psi\;/Ψ/g;s/&#937\;/Ω/g" \
		-e "s/&Omega\;/Ω/g;s/&lsquo\;/‘/g;s/&rsquo\;/’/g" \
		-e "s/&ldquo\;/“/g;s/&rdquo\;/”/g;s/&hellip\;/…/g" \
		-e "s/&#.*\;/\ /g;s///g;/^$/d" <<<"${subtitles}"
	[ "${silent}" -gt 1 ] || printf '%.0s─' {1..50} | sed 's/$/\n/;s/^/\n/' 
	}

#s/<++>/<++>/g;s/<++>/<++>/g;s/<++>/<++>/g; \ printf " -\033[%db\n" 30
# printf '%.0s─' {1..50} | sed 's/$/\n/'────
		#subtitles=$(curl -s "https://www.rentanadviser.com/subtitles/"${j}""  --data-raw "__EVENTTARGET=ctl00%24ContentPlaceHolder1%24btnlyricssimple&__EVENTARGUMENT=&ctl00%24ContentPlaceHolder1%24txtsearchsubtitle=Search+Lyrics+%26+Subtitles&ctl00%24ContentPlaceHolder1%24Overcome_Enter_problem_in_IE2=&__VIEWSTATEGENERATOR=66AB0ACC&__EVENTVALIDATION=%2FwEdAAc1IMvXZTlKndv0NmaipAivRuJmd8xHp1FvBUnaqp%2B06DOW6IPr5umq7%2FycngDpTXNPEZhaFWAVLa9NYjlVHx4aJjCeau28td%2F8t%2FqvcxlGDDVEIdCp7rHvjPYBfOzgHfb4tKtnA4BXTFp2YJ3Oy2DwsaRcyBfwvMw6aiaT4XgtZJHueYmw1ISTUKv9Zm27Ung%3D&__VIEWSTATE=%2FwEPDwUKLTkwMzA4NTY5Ng8WBh4JUm9vdGhQYXRoBUBDOlxJbmV0cHViXHZob3N0c1xyZW50YW5hZHZpc2VyLmNvbVxodHRwZG9jc1xBcHBfRGF0YVxzdWJzXGRhdGFcHgdzdWJQYXRoBWJDOlxJbmV0cHViXHZob3N0c1xyZW50YW5hZHZpc2VyLmNvbVxodHRwZG9jc1xBcHBfRGF0YVxzdWJzXGRhdGFcQXNoZS1JJ20tRmluZS0oT2ZmaWNpYWwtQXVkaW8pLnNydB4JUGFnZVBhcm1zBTM%2FYXJ0aXN0PUFzaGUmc29uZz1JJTI3bSUyMEZpbmUlMjAoT2ZmaWNpYWwlMjBBdWRpbylkZPE4RGupSuA1gbnhWQA0ERP4f46tA%2FW6Vb4Ek4dnYll%2B" | sed '/RentAnAdviser.com/d')

gotnothing () {
	[ "${silent}" == 1 ] && printf '%.0s─' {1..50} | sed 's/$/\n/'
	[ "${silent}" -gt 1 ] || printf "We've got nothing, Jesse...\n"
	[ "${silent}" -gt 1 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
	exit 1
}

megalobiz () {
	while read -r j
	do
		[ "${silent}" -gt 0 ] || echo "Scraping megalobiz for "${j}"..."
		[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
		subtitles=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.megalobiz.com"${j}"" \
			| grep "^\[......[0-9]*\].*"\
			| awk -F '<' '{print $1}')
		[ "${silent}" -gt 0 ] || echo "Curating lyrics..."
		[ "${silent}" -gt 1 ] || printf '%.0s─' {1..50} | sed 's/$/\n\n/'
		curate
		exit 0
	done <<<"${qryresult}"
}


rentad () {
	while IFS='\n' read -r j
	do
		[ "${silent}" -gt 0 ] || echo "Scraping rentanadviser for "${j}"..."
		[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
		actualsub=$(sed 's/%20/+/g' <<<"${j}")
		eventtarget=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.rentanadviser.com/subtitles/"${j}"")
		eventvalid=$(grep EVENTVALIDATION <<<"${eventtarget}" \
			| grep -o "value=\"/.*\"" \
			| awk -F '"' '{print $2}' \
			| sed "s/\//%2F/g;s/+/%2B/g;s/=/%3D/g")
		viewstategen=$(grep VIEWSTATEGENERATOR <<<"${eventtarget}" \
			| grep -o "value=\".*\"" \
			| awk -F '"' '{print $2}' \
			| sed "s/\//%2F/g;s/+/%2B/g;s/=/%3D/g")
		viewstate=$(grep VIEWSTATE\" <<<"${eventtarget}" \
			| grep -o "value=\".*\"" \
			| awk -F '"' '{print $2}' \
			| sed "s/\//%2F/g;s/=/%3D/g;s/+/%2B/g")
#		subtitles=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.rentanadviser.com/subtitles/"${j}"" \
#			| grep -m 1 "^\[.*" \
#			| sed "s/<br\ \/>/\n/g" \
#			| sed '/RentAnAdviser.com/d')
		subtitles=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.rentanadviser.com/subtitles/"${actualsub}""  -H "referer: https://www.rentanadviser.com/subtitles/"${j}""  --data-raw "__EVENTTARGET=ctl00%24ContentPlaceHolder1%24btnlyricssimple&__EVENTARGUMENT=&ctl00%24ContentPlaceHolder1%24txtsearchsubtitle=Search+Lyrics+%26+Subtitles&ctl00%24ContentPlaceHolder1%24Overcome_Enter_problem_in_IE2=&__VIEWSTATEGENERATOR="${viewstategen}"&__EVENTVALIDATION="${eventvalid}"&__VIEWSTATE="${viewstate}"" --compressed \
			| sed '/RentAnAdviser.com/d')

		[ "${silent}" -gt 0 ] || echo "Curating lyrics..."
		[ "${silent}" -gt 1 ] || printf '%.0s─' {1..50} | sed 's/$/\n\n/'
		curate
		exit 0
	done <<<"${qryresult}"
}


if [ "${rent}" == 0 ]; then
	[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50}  | sed 's/$/\n/'
	[ "${silent}" -gt 0 ] || echo "Querying for ${!qryin}..."
	[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
	query=$(sed 's/\ /+/g' <<<"${!qryin}")
	qryresult=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.megalobiz.com/search/all?qry="${query}"" \
		| grep -o '"/lrc/maker/.*"' \
		| grep title \
		| awk -F '"' '{ print $2}' \
		| head -n ${headnumb} | tail -n ${tailnumb})
	[[ "${qryresult}" == "" ]] && gotnothing
	megalobiz
	exit 0
else
	[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
	[ "${silent}" -gt 0 ] || echo "Querying for ${!qryin}..."
	[ "${silent}" -gt 0 ] || printf '%.0s─' {1..50} | sed 's/$/\n/'
	query=$(sed 's/\ /%20/g' <<<"${!qryin}")


	qryresult=$(/data/data/com.termux/files/home/.local/bin/curl -s "https://www.rentanadviser.com/subtitles/subtitles4songs.aspx?q="${query}"" \
		| grep -o "\"getsubtitle.aspx.*\"" \
		| awk -F '\"' '{print $2}' \
		| head -n ${headnumb} \
		| tail -n ${tailnumb})
	[[ "${qryresult}" == "" ]] && gotnothing
	rentad
	exit 0
fi
