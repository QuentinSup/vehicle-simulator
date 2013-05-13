GITHUB_BRANCH="grenoble"
APP_PROFILE="grenoble"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
APP_FOLDER_TMP=$SCRIPT_DIR/../feed/app/tmp/$APP_PROFILE
PACKAGE_FOLDER=/tmp/simcity-$GITHUB_BRANCH
PACKAGE_CACHE=$PACKAGE_FOLDER/feed/app/tmp/$APP_PROFILE/cache
PACKAGE_GZIP_FILE=$SCRIPT_DIR/simcity-$GITHUB_BRANCH.tar.gz

# PREPARE APP FOLDERS
rm -rf $PACKAGE_FOLDER
mkdir -p $PACKAGE_FOLDER/feed

git archive $GITHUB_BRANCH | tar -x -C $PACKAGE_FOLDER

cd $SCRIPT_DIR/../feed && git archive master | tar -x -C $PACKAGE_FOLDER/feed

mkdir -p $PACKAGE_CACHE/running_sec
mkdir -p $PACKAGE_CACHE/vehicles
mkdir -p $PACKAGE_CACHE/station_deps
chmod 0777 $PACKAGE_CACHE
chmod 0777 $PACKAGE_CACHE/running_sec
chmod 0777 $PACKAGE_CACHE/vehicles
chmod 0777 $PACKAGE_CACHE/station_deps

cp $APP_FOLDER_TMP/db_export.db $PACKAGE_CACHE/../

rm -rf $PACKAGE_GZIP_FILE
cd /tmp && tar -czf $PACKAGE_GZIP_FILE simcity-$GITHUB_BRANCH

scp $PACKAGE_GZIP_FILE vasilech@vasile.ch:/home6/vasilech/public_html/tmp

ssh vasilech@vasile.ch "cd /home6/vasilech/public_html/tmp/ && tar --preserve-permissions -xf simcity-grenoble.tar.gz && rm -rf ../_ch_vasile_simcity/grenoble/ && mv simcity-grenoble ../_ch_vasile_simcity/grenoble/"

rm -f $PACKAGE_GZIP_FILE
