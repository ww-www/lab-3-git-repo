#!/bin/bash

export LOCAL_REMOTE_NAME="lab-4.git"
export REMOTE_URL="https://github.com/gradientTS/curriculum-linux-lab-4.git"
export REMOTE_DIR_NAME=$(echo $REMOTE_URL | rev | cut -d '/' -f 1 | rev | cut -d '.' -f 1)
export REMOTE_NEW_PATH=$(pwd)/${LOCAL_REMOTE_NAME}

# create a local remote
mkdir ${LOCAL_REMOTE_NAME}
cd ${LOCAL_REMOTE_NAME}
git init --bare
cd ..

# clone the lab and get all branches/tags
#TODO: we need to create a service account / token to pull this (avoiding 2FA)
git clone ${REMOTE_URL}
cd ${REMOTE_DIR_NAME}
git fetch --all --tags
git pull --all --tags
for i in `git branch -a | grep remote | grep -v HEAD`; do git branch --track ${i#remotes/origin/} $i; done

# swap out to the local remote, push all
git remote set-url origin file://${REMOTE_NEW_PATH}
git push --all
git push --tags
cd ..
rm -rf ${REMOTE_DIR_NAME}

# clone from the local remote
git clone ${LOCAL_REMOTE_NAME}
