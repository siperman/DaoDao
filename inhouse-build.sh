#! /bin/bash

# example:
# ./inhouse-build.sh -s DaoDao -c Release -p "DaoDaoTest" -t xxxx

# logfile="build.log"
# exec > $logfile 2>&1

# check `fir-cli` install or not
command -v fir >/dev/null 2>&1 || { echo >&2 "Require `fir` to publish the ipa file, please run `gem install fir-cli` first"; exit 1; }

# Usage
showuUsage() {
  echo >&2 "Usage:"
  echo >&2 "        build -s <scheme> -c <configureation> -p <provisioning_file> -t <fir_token>"
}

# Parse params
while getopts "s:c:p:t:" arg
do
  case $arg in
    "s")
      SCHEME=$OPTARG
      ;;
    "c")
      CONFIGURATION=$OPTARG
      ;;
    "t")
      TOKEN=$OPTARG
      ;;
    "p")
      PROFILE=$OPTARG
      ;;
    "?")
      showuUsage
      exit 1
      ;;
  esac
done

echo >&2 "scheme is $SCHEME, configureation is $CONFIGURATION, token is $TOKEN"

TIMESTAMP=`date +"%m-%d-%y %H-%M-%S"`

DIR_NAME="$SCHEME-$CONFIGURATION"
FILE_NAME="$SCHEME $TIMESTAMP"

ARCHIVE_PATH="build/$DIR_NAME/$FILE_NAME.xcarchive"
IPA_PATH="build/$DIR_NAME/$FILE_NAME.ipa"

xcodebuild -workspace DaoDao.xcworkspace -scheme $SCHEME -configuration $CONFIGURATION -archivePath "$ARCHIVE_PATH" archive

xcodebuild -exportArchive -exportFormat IPA -archivePath "$ARCHIVE_PATH" -exportPath "$IPA_PATH"  -exportProvisioningProfile "$PROFILE"

rm -rf "$ARCHIVE_PATH"

fir publish "$IPA_PATH" -T $TOKEN

# post desktop notification if installed `terminal-notifier`
# $ [sudo] gem install terminal-notifier
if hash terminal-notifier 2>/dev/null; then
  terminal-notifier -message "Upload Success"
fi
