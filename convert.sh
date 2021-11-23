#!/bin/bash

DIR="$(realpath "$0")"
DIR="$(dirname "$DIR")"
cd "$DIR" || exit

langs=("en" "ru")
systems=('common' 'linux')
manSection="1"

tldconv() {
	cname=$(head -1 "$1"|cut -c3-|tr '[:lower:]' '[:upper:]')
	disc=$(head -3 "$1" | tail -1 |cut -c3-)
	echo '.\" The TLDR project'
	echo ".TH LS \"$manSection\" \"$(date +%%\ %B\ %Y)\" \"The TLDR project\" \"Commands\""
	echo ".SH NAME"
	echo "$cname \- $disc"
	echo ".SH DESCRIPTION"
	tail -n +4 "$1" |sed 's/^- /.IP *\n/' |sed 's/^`/.in +4m\n.B /' |sed 's/`$/\n.in\n/' |sed 's/^> / /'
}

doProcess(){
	sys=$1
	lng=$2
	if [[ "$lng" != "en" ]]; then
		trgDir="man/$lng/man$manSection"
		srcDir="tldr/pages.$lng/$sys"
	else
		trgDir="man/man$manSection"
		srcDir="tldr/pages/$sys"
	fi
	echo "Processing pages of the system '$sys' to the language '$lng'."
	echo "from '$srcDir' to '$trgDir'"

	mkdir -p "$trgDir" || exit
	find "$srcDir" -type f -iname "*.md"|
	while IFS= read -r file; do
		name=$(basename "$file" .md)
		tldconv "$file" |gzip -9c > "$trgDir/$name.$manSection.gz"
	done

}


for  lng in "${langs[@]}"; do
	for  sys in "${systems[@]}"; do
		doProcess "$sys" "$lng"
	done
done


