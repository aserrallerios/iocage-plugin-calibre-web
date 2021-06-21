#!/bin/sh

./usr/local/migration/update.sh


echo "Update Calibre-Web installation"

git_url="https://github.com/janeczku/calibre-web.git"

installdir="/usr/local/app/calibre-web"

echo "Re-init git"
rm -rf $installdir/.git
git -C $installdir init

echo "Setting git remote to ${git_url}"
git -C $installdir remote add origin ${git_url}

echo "Reset calibre-web to latest master"
git -C $installdir fetch origin master
git -C $installdir reset --hard origin/master

echo "Git cleanup"
git -C $installdir clean -f -d

echo "Installing requirements"
pip install -U -r $installdir/requirements.txt
pip install -U -r $installdir/optional-requirements.txt

chown -R calibreweb:calibreweb $installdir

sysrc "calibre_web_enable=YES"

service calibre_web restart
