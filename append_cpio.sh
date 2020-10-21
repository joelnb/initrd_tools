#! /bin/bash

set -eu

function append_cpio() {
	local initrd="$1"
	shift
	local newcpio="$1"

	# Ensure the original initrd and appended cpio are properly separated (buffer-format.txt)
	while echo -ne '\0' >> "${initrd}" ; do
		size="$(stat -c "%s" "${initrd}")"
		if [ "$((size % 4))" = "0" ] ; then
			break
		fi
	done

	# Append new content
	cat "${newcpio}" >> "${initrd}"

	# Ensure the alignment is correct for any further appended CPIOs
	while echo -ne '\0' >> "${initrd}" ; do
		size="$(stat -c "%s" "${initrd}")"
		if [ "$((size % 4))" = "0" ] ; then
			break
		fi
	done
}

append_cpio "$1" "$2"
