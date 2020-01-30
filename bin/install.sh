#!/bin/bash
export HARNESS_ORG=${1:-fitrankings}
export HARNESS_PROJECT=${2:-fr-harness}
export HARNESS_BRANCH=${3:-master}
export GITHUB_REPO="https://github.com/${HARNESS_ORG}/${HARNESS_PROJECT}.git"

if [ "$HARNESS_PROJECT" ] && [ -d "$HARNESS_PROJECT" ]; then
  echo "Removing existing $HARNESS_PROJECT"
  rm -rf "$HARNESS_PROJECT"
fi

echo "Cloning ${GITHUB_REPO}#${HARNESS_BRANCH}..."
git clone -b $HARNESS_BRANCH $GITHUB_REPO