#!/bin/bash

branches="
master
leia
"

leia="
script.tvguide.fullscreen
"

master="
plugin.video.bbc 
plugin.audio.bbc
"

for branch in $branches; do
	echo $branch
	mkdir $branch
	echo "<?xml version="1.0" encoding="UTF-8" standalone="yes"?>" > $branch/addons.xml
	echo "<addons>" >> $branch/addons.xml
	for addon in ${!branch}; do
		echo $addon
		git clone https://github.com/primaeval/$addon.git
		cd $addon/
		git fetch
		git checkout $branch
		tag=$(git describe --abbrev=0 --tags)
		echo
		echo $tag
		echo
		git checkout $tag
		cd -
		mkdir $branch/$addon/
		for file in "addon.xml changelog.txt icon.png fanart.jpg"; do
			cp $addon/$file $branch/$addon/
		done
		/c/Program\ Files/7-Zip/7z.exe a -xr@exclude $branch/$addon/$addon-$tag.zip $addon
		tail -n+2 $addon/addon.xml >> $branch/addons.xml 
	done
	echo "</addons>" >> $branch/addons.xml
	(cd $branch && md5sum addons.xml > addons.xml.md5)
done