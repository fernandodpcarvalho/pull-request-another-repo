#!/bin/sh

set -e
set -x

if [ -z "$INPUT_SOURCE_FOLDER" ]
then
  echo "Source folder must be defined"
  return -1
fi

if [ $INPUT_DESTINATION_BRANCH == "main" ] || [ $INPUT_DESTINATION_BRANCH == "master"]
then
  echo "Destination branch cannot be 'main' nether 'master'"
  return -1
fi

CLONE_DIR=$(mktemp -d)

echo "Cloning destination git repository"
git config --global user.email "$INPUT_USER_EMAIL"
git config --global user.name "$INPUT_USER_NAME"
export GITHUB_TOKEN=$API_TOKEN_GITHUB
git clone "https://$API_TOKEN_GITHUB@github.com/$INPUT_DESTINATION_REPO.git" "$CLONE_DIR"
git checkout -b "$INPUT_DESTINATION_BRANCH"

echo "Copying contents to git repo"
cp -R $INPUT_SOURCE_FOLDER "$CLONE_DIR/$INPUT_DESTINATION_FOLDER"
cd "$CLONE_DIR"

echo "Adding git commit"
git add .
if git status | grep -q "Changes to be committed"
then
  git commit --message "Update from https://github.com/$GITHUB_REPOSITORY/commit/$GITHUB_SHA"
  echo "Pushing git commit"
  git push -u origin HEAD:$INPUT_DESTINATION_BRANCH
  # echo 'Authentication on git hub cli'
  # gh auth login
  echo "Creating a pull request"
  gh pr create --reviewer fernandodpcarvalho
else
  echo "No changes detected"
fi
