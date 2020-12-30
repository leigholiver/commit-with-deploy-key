#!/bin/sh -l
set -e

if [ ! -f "${INPUT_SOURCE}" ] && [ ! -d "${INPUT_SOURCE}" ]; then
  echo "No source specified"
  exit 1
fi

# set up some directories
CALLING_DIR=$(pwd)
WORKING_DIR=$(mktemp -d)

# set up the github deploy key
mkdir -p ~/.ssh
echo "${INPUT_DEPLOY_KEY}" > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# set up git
git config --global user.name "${INPUT_GIT_USERNAME}"
git config --global user.email "${INPUT_GIT_EMAIL}"
ssh-keyscan -H github.com > ~/.ssh/known_hosts
GIT_SSH='ssh -i /github/home/.ssh/id_rsa -o UserKnownHostsFile=/github/home/.ssh/known_hosts'

# clone the repo into our working directory and cd to it
GIT_SSH_COMMAND=$GIT_SSH git clone git@github.com:$INPUT_DESTINATION_REPO.git $WORKING_DIR
cd $WORKING_DIR

# checkout the destination branch, creating it if it doesn't exist
git checkout $INPUT_DESTINATION_BRANCH || git checkout -b $INPUT_DESTINATION_BRANCH

# ensure destination directory exists, and is emptied if appropriate
REAL_DESTINATION=$(realpath $WORKING_DIR/$INPUT_DESTINATION_FOLDER)/
mkdir -p $REAL_DESTINATION
cd $REAL_DESTINATION
if [ "${INPUT_DELETE_DESTINATION}" = "true" ]; then
    git rm -rf .
fi

# do the copy
if [ -f $CALLING_DIR/$INPUT_SOURCE ]; then
    cp -a $CALLING_DIR/$INPUT_SOURCE .
elif [ -d $CALLING_DIR/$INPUT_SOURCE ]; then
    cp -a $CALLING_DIR/$INPUT_SOURCE/* .
fi

# commit and push
git add .
git commit -m "${INPUT_COMMIT_MESSAGE}"
GIT_SSH_COMMAND=$GIT_SSH git push -u origin $INPUT_DESTINATION_BRANCH

# output the commit hash
echo "::set-output name=commit_hash::$(git rev-parse HEAD)"
exit 0
