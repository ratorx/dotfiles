#!/usr/bin/env zsh
antibody() {
	case "$1" in
	bundle)
		source <( /usr/local/bin/antibody $@ ) 2> /dev/null || /usr/local/bin/antibody $@
		;;
	*)
		/usr/local/bin/antibody $@
		;;
	esac
}

_antibody() {
	IFS=' ' read -A reply <<< "$(echo "bundle update list home init help")"
}
compctl -K _antibody antibody
