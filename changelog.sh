#!/bin/bash
package=$1
echo ${package}
current_branch=$(git rev-parse --abbrev-ref HEAD)
last_release_tag=$(git describe --tags --match 'test-'${package}'-tocco@*' --abbrev=0 ${current_branch})

last_version=$(echo ${last_release_tag} | awk -F '@' '{print $2}')

changelog=$(git log --pretty='%b' "${last_release_tag}"..HEAD --grep="${package}" --reverse | grep -E '^Changelog:' | awk '{gsub("Changelog:", "- ", $0); print}')
echo -e  "${changelog}"
