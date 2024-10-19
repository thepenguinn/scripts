#!/bin/sh

Bin_Dir="${HOME}/.local/bin"

mkdir "${Bin_Dir}" -p > /dev/null 2>&1

chmod_and_link () {
    chmod +x "$1"
    ln -s "$1" "$2" > /dev/null 2>&1
}

chmod_and_link "${PWD}/epubconv/epubconv" "${Bin_Dir}"
chmod_and_link "${PWD}/gen-cover-img/gen-cover-img" "${Bin_Dir}"
chmod_and_link "${PWD}/kdb/kdb" "${Bin_Dir}"
chmod_and_link "${PWD}/smu/smu" "${Bin_Dir}"
chmod_and_link "${PWD}/splitpdf/splitpdf" "${Bin_Dir}"
chmod_and_link "${PWD}/viewpdf/viewpdf" "${Bin_Dir}"
chmod_and_link "${PWD}/tss/tss" "${Bin_Dir}"
chmod_and_link "${PWD}/tss/tsl" "${Bin_Dir}"
chmod_and_link "${PWD}/tss/tsm" "${Bin_Dir}"
chmod_and_link "${PWD}/glrclib/glrclib" "${Bin_Dir}"
chmod_and_link "${PWD}/perc/perc" "${Bin_Dir}"
chmod_and_link "${PWD}/pyexec/pyexec" "${Bin_Dir}"
chmod_and_link "${PWD}/pyexec/view-server-pyexec" "${Bin_Dir}"
chmod_and_link "${PWD}/pyexec/exec-server-pyexec" "${Bin_Dir}"
chmod_and_link "${PWD}/texnotes/gen-rad-range" "${Bin_Dir}"
chmod_and_link "${PWD}/texnotes/texno" "${Bin_Dir}"
chmod_and_link "${PWD}/stm/stm" "${Bin_Dir}"
