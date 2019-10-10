#!/bin/bash

TASK="build"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -t|--task)
    TASK="$2"
    shift # past argument
    shift # past value
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo TASK  = "$TASK"

if [ "$TASK" = "build" ]; then
	npm install -g gulp-cli
	npm install

	gulp styles --themes Default,DeepForest,Funny,Sand --build a
	gulp js:build --build a
	gulp js:min --build a
	gulp test
	
	PRODUCT_VERSION=`cat VERSION`
	
	echo CREATE ZIP FILE  = "${PRODUCT_NAME}_${PRODUCT_VERSION}.zip"
	
	zip -r ${PRODUCT_NAME}_${PRODUCT_VERSION}.zip data/settings/config.json data/settings/modules modules static system vendor dev ".htaccess" build.php dav.php index.php LICENSE VERSION README.md CHANGELOG.txt favicon.ico robots.txt package.json composer.json composer.lock modules.json gulpfile.js pre-config.json -x **/*.bak *.git*
fi

if [ "$TASK" = "upload" ]; then
	PRODUCT_VERSION=`cat VERSION`

	echo UPLOAD ZIP FILE  = "${PRODUCT_NAME}_${PRODUCT_VERSION}.zip"
	
	curl --ftp-create-dirs --retry 6 -T ${PRODUCT_NAME}_${PRODUCT_VERSION}.zip -u ${FTP_USER}:${FTP_PASSWORD} ftp://afterlogic.com/
fi
