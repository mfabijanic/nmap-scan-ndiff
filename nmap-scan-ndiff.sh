#!/bin/bash
#
# Description:
# Scan with nmap periodically and check differences.
#
# Author: Matej Fabijanić <root4unix@gmail.com>
#

PATH="/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"
VERSION='0.0.1'
work="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
config="$work/nmap-scan-ndiff.conf"
date="$(date +%F)"


if [ -e "$config" ]; then
    # shellcheck source=/dev/null
    source "$config"
else
    echo "Configuration file \"$config\" does not exist."
    exit 1
fi


show_usage() {
    cat << USAGE
$(basename "${BASH_SOURCE[0]}") [OPTION]

OPTIONS
  -h, --help      show this message and exit
  -v, --version   print version information and exit
USAGE
}

# Default values. Override in configuration file.
set_defaults() {
    [ -z "$TARGETS" ] && TARGETS="127.0.0.1"
    [ -z "$NMAP_OPTIONS" ] && NMAP_OPTIONS="-v -T4 -p1-65535 -sV"
    [ -z "$SCANS" ] && SCANS="$work/scans"
    [ -z "$SCAN" ] && SCAN="scan-${date}"
    [ -z "$NDIFF" ] && NDIFF="ndiff-${date}"
}

pre_scan() {
    if [ ! -d "$SCANS" ]; then
        mkdir -p "$SCANS"
        chmod 700 "$SCANS"
    fi

    cd "$SCANS" || { echo "Can't access directory \"$SCANS\""; exit 1; }

    if [ -f "${SCAN}.xml" ]; then
        echo "${SCANS}/${SCAN}.xml - this scan already exist. Aborting scan."
        echo
        exit
    fi

    if ! (command -v nmap ndiff xsltproc &> /dev/null); then
        echo "ERROR: You must have installed: nmap, ndiff and xsltproc."
        exit 1
    fi
}

# Nmap scan
nmap_scan() {
    nmap_cmd="nmap $NMAP_OPTIONS -oA $SCAN $TARGETS"
    echo "NMAP CMD:    $nmap_cmd"
    echo "TARGETS:     $TARGETS"
    echo
    # Nmap scan
    ${nmap_cmd}
    # Nmap results
    echo
    echo "*** NMAP RESULTS ***"
    cat "${SCAN}.nmap"
}

# Nmap diff
nmap_diff() {
    if [ -e scan-prev.xml ]; then
        ndiff --text scan-prev.xml "${SCAN}.xml" > "$NDIFF"
        ndiff --xml scan-prev.xml "${SCAN}.xml" > "$NDIFF.xml"
        echo
        echo "*** NDIFF RESULTS ***"
        cat "$NDIFF"
        echo
    fi
}

# Convert XML result to HTML format
convert_xml2html() {
    if (command -v xsltproc &> /dev/null); then
        echo
        echo "Convert \"${SCAN}.xml\" -> \"${SCAN}.html\""
        xsltproc "${SCAN}.xml" -o "${SCAN}.html"
        echo
    fi
}

scan_result_info() {
    cat << SCANINFO
Scan info:
- scan results:
  - XML:  "${SCANS}/${SCAN}.xml"
  - HTML: "${SCANS}/${SCAN}.html"
- nmap diff:
  - XML:  "${SCANS}/${NDIFF}.xml"
SCANINFO
}

main() {
    set_defaults
    pre_scan
    nmap_scan
    nmap_diff
    convert_xml2html
    # Link this scan as previous scan
    ln -sf "${SCAN}.xml" scan-prev.xml
    ln -sf "${NDIFF}.xml" ndiff-prev.xml
    scan_result_info
}


if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    for opt in "$@"; do
        case ${opt} in
        -h | --help)
            show_usage
            exit 0
            ;;
        -v | --version)
            echo "${VERSION}"
            exit 0
            ;;
        *)
            echo "Error: unknown option ${opt}" >&2
            exit 2
            ;;
        esac
    done

    main
fi
