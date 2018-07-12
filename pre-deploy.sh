#!/bin/bash

OUTDIR=$TRAVIS_BUILD_DIR/out/$TRAVIS_PULL_REQUEST/$TRAVIS_JOB_NUMBER-$HOST
mkdir -p $OUTDIR/bin

echo $TRAVIS_BUILD_DIR

ARCHIVE_CMD="zip"

if [[ $HOST = "i686-w64-mingw32" ]]; then
  ARCHIVE_NAME="windows-x86.zip"
elif [[ $HOST = "x86_64-w64-mingw32" ]]; then
    ARCHIVE_NAME="windows-x64.zip"
elif [[ $HOST = "arm-linux-gnueabihf" ]]; then
    ARCHIVE_NAME="arm-x86.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "aarch64-linux-gnu" ]]; then
    ARCHIVE_NAME="arm-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-unknown-linux-gnu" ]]; then
    ARCHIVE_NAME="linux-x64.tar.gz"
    ARCHIVE_CMD="tar -czf"
elif [[ $HOST = "x86_64-apple-darwin11" ]]; then
    ARCHIVE_NAME="osx-x64.zip"
fi

if [[ $HOST = "x86_64-apple-darwin11" ]]; then
    find $TRAVIS_BUILD_DIR -type f | grep -i Jiyo-Core.dmg$ | xargs -i cp {} $OUTDIR/bin
else
    cp $TRAVIS_BUILD_DIR/src/qt/jiyo-qt $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/qt/jiyo-qt.exe $OUTDIR/bin/ || echo "no QT Wallet"
    cp $TRAVIS_BUILD_DIR/src/jiyod $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/jiyod.exe $OUTDIR/bin/
    cp $TRAVIS_BUILD_DIR/src/jiyo-cli $OUTDIR/bin/ || cp $TRAVIS_BUILD_DIR/src/jiyo-cli.exe $OUTDIR/bin/
    strip "$OUTDIR/bin"/* || echo "nothing to strip"
    ls -lah $OUTDIR/bin
fi

cd $OUTDIR/bin
ls -ah
ARCHIVE_CMD="$ARCHIVE_CMD $ARCHIVE_NAME *"
eval $ARCHIVE_CMD

mkdir -p $OUTDIR/zip
mv $ARCHIVE_NAME $OUTDIR/zip

sleep $[ ( $RANDOM % 6 )  + 1 ]s
