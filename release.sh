#!/bin/bash

package=$1

color_blue=`tput setaf 4`
color_green=`tput setaf 2`
color_reset=`tput sgr0`

current_branch=$(git rev-parse --abbrev-ref HEAD)
last_release_tag=$(git describe --tags --match 'test-'${package}'-tocco@*' --abbrev=0 ${current_branch})

last_version=$(echo ${last_release_tag} | awk -F '@' '{print $2}')

changelog=$(git log --pretty='%b' "${last_release_tag}"..HEAD --grep="${package}" --reverse | grep -E '^Changelog:' | awk '{gsub("Changelog:", "- ", $0); print}')

echo "---------------------"
echo "info latest release tag: ${color_blue}${last_release_tag} ${color_reset}"
echo "info latest version: ${color_blue}${last_version}${color_reset}"
echo -e  "Generated changelog:\n${color_blue}${changelog}${color_reset}"


read -p "question New version: : " new_version

cd packages/${package}

changelog_file="./changelog.md"
tmp_file="./tmp_changelog.md"

(echo  -e "${new_version}\n${changelog}\n" && cat "${changelog_file}") > "${tmp_file}" && mv "${tmp_file}" "${changelog_file}"
read -p "Edit the changelog and press enter to continue"

git commit -m "docs(${package}): changelog ${new_version}" ${changelog_file}
echo "publishing ${package} with version ${new_version}"
yarn publish --new-version ${new_version}
echo "${color_green} Published! Now you push!${color_reset}"
echo "---------------------"
