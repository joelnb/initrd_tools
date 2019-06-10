#! /bin/bash

set -euo pipefail
IFS=$'\n\t'

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OUTDIR="$(pwd)"
VERBOSE=

usage() {
    cat <<EOF 2>&1
Usage: $(basename "$0") INITRD

ARGUMENTS:
    INITRD      The initrd file to unpack

OPTIONS:
    -o DIR      Output to DIR rather than the current directory
EOF
    exit 1
}

echo_verbose() {
    if [ -n "${VERBOSE}" ]; then
        echo "$@"
    fi
}

while getopts "o:V" OPTION; do
    case $OPTION in
        o)
            OUTDIR="${OPTARG}"
            ;;
        V)
            VERBOSE=1
            ;;
        ?)
            usage
            ;;
    esac
done

shift $((OPTIND - 1))

INITRD_PATH="${1:-}"
[ -z "${INITRD_PATH}" ] && usage
shift

ITERATION=1
PROCESS_FILE="$(realpath "${INITRD_PATH}")"

while true; do
    mkdir -p "${OUTDIR}/${ITERATION}"
    echo_verbose "Processing iteration ${ITERATION} in: ${OUTDIR}/${ITERATION}"
    trailer="$(mktemp)"
    echo_verbose "Using temporary file ${trailer} for any trailing data"

    if [ "$(file -bL "${PROCESS_FILE}")" = "empty" ]; then
        rm -rf "${OUTDIR:?}/${ITERATION}"
        echo "No more content to extract from archive. Extracted $((ITERATION - 1)) CPIO archives."
        break
    elif [ "$(file -bL "${PROCESS_FILE}")" = "ASCII cpio archive (SVR4 with no CRC)" ]; then
        pushd "${OUTDIR}/${ITERATION}"
        (cpio -idmv; cat > "${trailer}") < "${PROCESS_FILE}"
        popd
    else
        GZIP_LEN=$("${SCRIPT_DIR}/gzip-length" "${PROCESS_FILE}")
        dd "if=${PROCESS_FILE}" "of=${trailer}" bs=1 "skip=$(python -c "print(${GZIP_LEN} + (4 - (${GZIP_LEN} % 4)))")"

        ORIG_PROCESS_FILE="${PROCESS_FILE}"
        PROCESS_FILE="$(mktemp)"
        dd "if=${ORIG_PROCESS_FILE}" "of=${PROCESS_FILE}" "bs=${GZIP_LEN}" count=1

        pushd "${OUTDIR}/${ITERATION}"
        gzip -dc < "${PROCESS_FILE}" | cpio -idmv
        popd
    fi

    PROCESS_FILE="${trailer}"

    (( ITERATION++ ))
done
