#/bin/bash

#
# Pump one or both of the server/mobile versions in appropriate files
#
# usage: './scripts/pump-version.sh -s <major|minor|patch> <-m>
#
# examples:
#    ./scripts/pump-version.sh -s major        # 1.0.0+50 => 2.0.0+50
#    ./scripts/pump-version.sh -s minor -m     # 1.0.0+50 => 1.1.0+51
#    ./scripts/pump-version.sh -m              # 1.0.0+50 => 1.0.0+51
#

SERVER_PUMP="false"
MOBILE_PUMP="false"

while getopts 's:m:' flag; do
  case "${flag}" in
  s) SERVER_PUMP=${OPTARG} ;;
  m) MOBILE_PUMP=${OPTARG} ;;
  *)
    echo "Invalid args"
    exit 1
    ;;
  esac
done

CURRENT_SERVER=$(cat server/package.json | jq -r '.version')
MAJOR=$(echo $CURRENT_SERVER | cut -d '.' -f1)
MINOR=$(echo $CURRENT_SERVER | cut -d '.' -f2)
PATCH=$(echo $CURRENT_SERVER | cut -d '.' -f3)

if [[ $SERVER_PUMP == "major" ]]; then
  MAJOR=$((MAJOR + 1))
  MINOR=0
  PATCH=0
elif [[ $SERVER_PUMP == "minor" ]]; then
  MINOR=$((MINOR + 1))
  PATCH=0
elif [[ $SERVER_PUMP == "patch" ]]; then
  PATCH=$((PATCH + 1))
elif [[ $SERVER_PUMP == "false" ]]; then
  echo 'Skipping Server Pump'
else
  echo 'Expected <major|minor|patch|false> for the server argument'
  exit 1
fi

NEXT_SERVER=$MAJOR.$MINOR.$PATCH

CURRENT_MOBILE=$(cat mobile/pubspec.yaml | grep "^version: .*+[0-9]\+$" | cut -d "+" -f2)
NEXT_MOBILE=$CURRENT_MOBILE
if [[ $MOBILE_PUMP == "true" ]]; then
  set $((NEXT_MOBILE++))
elif [[ $MOBILE_PUMP == "false" ]]; then
  echo 'Skipping Mobile Pump'
else
  echo "Fatal: MOBILE_PUMP value $MOBILE_PUMP is invalid"
  exit 1
fi

if [ "$CURRENT_SERVER" != "$NEXT_SERVER" ]; then
  echo "Pumping Server: $CURRENT_SERVER => $NEXT_SERVER"
  npm --prefix server version $SERVER_PUMP
  make open-api
  poetry --directory machine-learning version $SERVER_PUMP
fi

if [ "$CURRENT_MOBILE" != "$NEXT_MOBILE" ]; then
  echo "Pumping Mobile: $CURRENT_MOBILE => $NEXT_MOBILE"
fi

sed -i "s/\"android\.injected\.version\.name\" => \"$CURRENT_SERVER\",/\"android\.injected\.version\.name\" => \"$NEXT_SERVER\",/" mobile/android/fastlane/Fastfile
sed -i "s/version_number: \"$CURRENT_SERVER\"$/version_number: \"$NEXT_SERVER\"/" mobile/ios/fastlane/Fastfile
sed -i "s/\"android\.injected\.version\.code\" => $CURRENT_MOBILE,/\"android\.injected\.version\.code\" => $NEXT_MOBILE,/" mobile/android/fastlane/Fastfile
sed -i "s/^version: $CURRENT_SERVER+$CURRENT_MOBILE$/version: $NEXT_SERVER+$NEXT_MOBILE/" mobile/pubspec.yaml

echo "IMMICH_VERSION=v$NEXT_SERVER" >>$GITHUB_ENV
