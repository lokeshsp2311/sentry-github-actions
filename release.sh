#!/usr/bin/env bash

export SENTRY_LOG_LEVEL="info"

# dont delete this comment - we keep this for using manual build
# Setting SENTRY environment variables defined in .env
#export SENTRY_AUTH_TOKEN=$(grep SENTRY_AUTH_TOKEN .env | cut -d '=' -f2 | sed 's/"//g')
#export SENTRY_ORG=$(grep SENTRY_ORG .env | cut -d '=' -f2 | sed 's/"//g')
#export SENTRY_PROJECT=$(grep SENTRY_PROJECT .env | cut -d '=' -f2 | sed 's/"//g')
#SENTRY_ENV=$(grep SENTRY_ENV .env | cut -d '=' -f2 | sed 's/"//g') # Getting SENTRY_ENV defined in .env

export SENTRY_ENV=dev
export SENTRY_AUTH_TOKEN=a50c331f121847cb89b840376e435cf1cfcb3e3e87cc41699f40133b4e215a46
export SENTRY_ORG=pc-dev
export SENTRY_PROJECT=pc-dev-1

echo $SENTRY_RELEASE;
echo $SENTRY_ENV

# 1. Initializing release
npx sentry-cli releases new $SENTRY_RELEASE

# 2. Associate commits
npx sentry-cli releases set-commits $SENTRY_RELEASE --auto # Auto

# 2. Do the build and 3. Upload artifacts

export NODE_ENV=production # NODE_ENV used by webpack at the time of bundling
npm run build # Bundling
#npm run sw # For Service Worker file generation

# 4. Finalizing release
npx sentry-cli releases finalize $SENTRY_RELEASE

# 5. Deploy - Install "jq" - sudo apt install jq
VERSION=$(jq -r '.version' package.json)
npx sentry-cli releases deploys $SENTRY_RELEASE new -e $SENTRY_ENV -n "pc-dev-v$VERSION"
