#!/bin/bash
dat_dir='/cubric/scanners/mri/7t/transfer/314_WAND'

find $dat_dir -iname '*mp2rage*' | xargs ls -l --block-size=k | awk '{print $5 " " $9}' > mpragefilesize.txt

echo 'total mp2rages: ' `wc mpragefilesize.txt| awk '{print $1}'`

echo 'Nfiles of size 9842689K:' `grep 9842689K mpragefilesize.txt | wc |awk '{print $1}'`
echo 'Nfiles of size 9846072K:' `grep 9846072K mpragefilesize.txt | wc | awk '{print $1}'`

echo
echo "mprages with non standard size:" 
grep -v 9846072K mpragefilesize.txt
