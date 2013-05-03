#!/bin/bash
scriptdir=$(cd $(dirname $0) && pwd)/scripts;

ftp esterhazy.web.fc2.com << EOS | $scriptdir/ftp2ls.pl > $scriptdir/remote.txt
cd ester
ls -lR
exit
EOS

find . -name "*" -type f | grep -v ".git" | grep -v -f .ignore \
   | xargs ls -l | grep -v "@" | sed -e 's/\.\///' > $scriptdir/local.txt

$scriptdir/syncftp.pl $scriptdir/local.txt $scriptdir/remote.txt

