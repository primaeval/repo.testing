#!/bin/bash

addons="
plugin.video.bbc 
plugin.audio.bbc
"

for addon in $addons; do
echo $addon
git clone https://github.com/primaeval/$addon.git
cd $addon/
git fetch
tag=$(git describe --abbrev=0 --tags)
echo
echo $tag
echo
git checkout $tag
cd -
/c/Program\ Files/7-Zip/7z.exe a -xr@exclude $addon-$tag.zip $addon
done
