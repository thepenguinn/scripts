#!/bin/sh

Bin_Dir="${HOME}/.local/bin"

mkdir "${Bin_Dir}" -p > /dev/null 2>&1

ln -s "${PWD}/epubconv/epubconv" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/gen-cover-img/gen-cover-img" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/kdb/kdb" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/smu/smu" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/splitpdf/splitpdf" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/viewpdf/viewpdf" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/tss/tss" "${Bin_Dir}" > /dev/null 2>&1
ln -s "${PWD}/tss/tsl" "${Bin_Dir}" > /dev/null 2>&1
