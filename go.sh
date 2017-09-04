#!/bin/bash

branches="
jarvis
krypton
"

krypton="
script.tvguide.fullscreen
script.tvguide.fullscreen.skin.carnelian
script.tvguide.fullscreen.skin.kjb85
script.tvguide.fullscreen.skin.lapis
script.tvguide.fullscreen.skin.onyx
script.tvguide.fullscreen.skin.tycoo
skin.confluence.wall
skin.estuary.wall
"

jarvis="
context.simple.favourites
plugin.audio.bbc
plugin.audio.favourites
plugin.program.downloader
plugin.program.fixtures
plugin.program.simple.favourites
plugin.video.addons.ini.creator
plugin.video.addons.ini.player
plugin.video.bbc
plugin.video.bbc.live
plugin.video.boilerroom
plugin.video.favourites
plugin.video.hls.playlist.player
plugin.video.iplayerwww
plugin.video.playlist.player
plugin.video.pvr.plugin.player
plugin.video.rageagain.again
plugin.video.replay
plugin.video.stream.searcher
plugin.video.tvlistings
plugin.video.tvlistings.xmltv
plugin.video.tvlistings.yo
repository.imdbsearch
repository.primaeval
script.games.play.mame
script.skin.tightener
script.tvguide.fullscreen
script.tvguide.fullscreen.skin.carnelian
script.tvguide.fullscreen.skin.kjb85
script.tvguide.fullscreen.skin.lapis
script.tvguide.fullscreen.skin.onyx
script.tvguide.fullscreen.skin.tycoo
script.webgrab
skin.confluence.wall
skin.naked
"

rm .gitignore
for branch in $branches; do
	echo $branch
	mkdir $branch
	echo "<?xml version="1.0" encoding="UTF-8" standalone="yes"?>" > $branch/addons.xml
	echo "<addons>" >> $branch/addons.xml
	for addon in ${!branch}; do
		echo $addon
		echo /$addon >> .gitignore
		git clone https://github.com/primaeval/$addon.git
		cd $addon/
		git fetch
		branchname=${branch/jarvis/master}
		git checkout $branchname
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