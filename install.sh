#~/bin/bash

script_file="update_git_project.sh"

echo "Where do you want bash script to be located? ($HOME/bin) > \c"
read location

cat ./lib/funct_current_epoch > $script_file

if [ -z "${location}" ]; then
  location="~/bin"
fi

echo "" >> ./update_git_project.sh
echo 'function _update_shared_git_projects() { ' >> $script_file
echo '  echo "LAST_EPOCH=$(_current_epoch)" >' "${location}/.git-projects-update" >> $script_file
echo '}' >> $script_file

echo "" >> ./update_git_project.sh
echo 'function _upgrade_shared_git_projects() {' >> $script_file

echo ""
echo "Enter locations for git projects to track - comma & space delim > \c"
read projects
for i in $(echo $projects | tr ",\ " "\n")
do
  echo '  echo "Updating '"$i"'"' >> $script_file
  echo "  cd $i" >> $script_file
  echo "  git status" >> $script_file
  echo "  git pull" >> $script_file
  echo "" >> $script_file
done
echo '}' >> $script_file

echo 'if [ -f '"${location}"'/.git-projects-update ];then' >> $script_file
echo '  # Last update exists, load last epoch' >> $script_file
echo '  . '"${location}"'/.git-projects-update' >> $script_file

cat ./lib/funct_main >> $script_file

overwrite=Y

cd $location
if [ -e  "$script_file" ]; then
  echo "${location}/${script_file} already exists. Overwrite? (y/n) > \c"
  read overwrite
fi
cd -

if [ "$overwrite" = Y ] || [ "$overwrite" = y ]; then
  echo ""
  echo "Copying bash script to final destination"
  eval "cp $script_file $location"
  eval "chmod +x $location/$script_file"
  echo ""
  echo "Done! Add the following line to your .bashrc, .zshrc or equivalent:"
  echo '[[ -s "'"$location/$script_file"'" ]] && source '"$location/$script_file"
else
  echo "Script file created but not installed to $location"
fi

