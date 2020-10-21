#! /bin/bash

set -eu

function append_cpio_dir() {
	local initrd="$1"
	shift
	local filesdir="$1"

	# Ensure the original initrd and appended cpio are properly separated (buffer-format.txt)
	while echo -ne '\0' >> "${initrd}" ; do
		size="$(stat -c "%s" "${initrd}")"
		if [ "$((size % 4))" = "0" ] ; then
			break
		fi
	done

	# Append new content
	pushd "${filesdir}" > /dev/null
	find . | cpio -H newc -o -R 0:0 >> "${initrd}"
	popd > /dev/null

	# Ensure the alignment is correct for any further appended CPIOs
	while echo -ne '\0' >> "${initrd}" ; do
		size="$(stat -c "%s" "${initrd}")"
		if [ "$((size % 4))" = "0" ] ; then
			break
		fi
	done
}

append_cpio_dir "$1" "$2"
