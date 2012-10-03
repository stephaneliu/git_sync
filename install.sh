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
  echo "" >> $script_file
  echo "########################" >> $script_file
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

echo ""
echo "Backing up $location/$script_file to $location/${script_file}.bak"
eval "touch $location/$script_file"
eval "mv $location/$script_file $location/${script_file}_bak"
echo ""
echo "Copying bash script to final destination"
eval "cp $script_file $location"
eval "chmod +x $location/$script_file"
echo ""
echo "Done! Add the following line to your .bashrc, .zshrc or equivalent:"
echo '[[ -s "'"$location/$script_file"'" ]] && source '"$location/$script_file"
