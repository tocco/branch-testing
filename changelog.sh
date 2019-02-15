#!/bin/bash

package=$1

current_branch=$(git rev-parse --abbrev-ref HEAD)
last_release_tag=$(git describe --tags --match 'test-'${package}'-tocco@*' --abbrev=0 ${current_branch})

echo "Last release: $last_release_tag"

changelog=$(git log --pretty='%b' ${last_release_tag}..HEAD --grep=''${package}'' --reverse | grep -E '^Changelog:' | awk '{gsub("Changelog:", "- ", $0); print}')

changelog_file="./packages/${package}/changelog.md"

echo "=======CHANGELOG======="
echo ${last_release_tag} | awk -F '@' '{print $2}' | tee -a "${changelog_file}"
echo "$changelog" | tee -a "${changelog_file}"
echo "======================="




