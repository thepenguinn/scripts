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
chmod_and_link "${PWD}/gdl/gdl" "${Bin_Dir}"
chmod_and_link "${PWD}/mono/mono" "${Bin_Dir}"
chmod_and_link "${PWD}/journey/journey" "${Bin_Dir}"
chmod_and_link "${PWD}/dwmlapstatus/dwmlapstatus" "${Bin_Dir}"
chmod_and_link "${PWD}/a50scpy/a50scpy" "${Bin_Dir}"
chmod_and_link "${PWD}/a50scpy/a50scpy-headless" "${Bin_Dir}"
chmod_and_link "${PWD}/qralarm/qralarm" "${Bin_Dir}"

# Checking whether we are on Android or not
# This is how pfetch checks for Android
if [ -d /system/app ] && [ -d /system/priv-app ]; then
    echo "pkgd: You need:"
    echo "      Permission to internal storage."
    echo "      Working Shizuku installed and rish setted up."
    echo "      \`aapt\` installed at \`/data/local/tmp/bin/\`."
    echo "      If you have already done these ignore this."

    mkdir "${HOME}/storage/shared/pkgdisabler" > /dev/null 2>&1
    mkdir "${HOME}/storage/shared/pkgdisabler/tmp" > /dev/null 2>&1
    mkdir "${HOME}/storage/shared/pkgdisabler/scripts" > /dev/null 2>&1
    cp "${PWD}/pkgd/getpkglist.sh" "${HOME}/storage/shared/pkgdisabler/scripts"
    chmod_and_link "${PWD}/pkgd/pkgd" "${Bin_Dir}"
fi
