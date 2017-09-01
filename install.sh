#!/bin/bash
# GEMICHELST PYLOAD-EXTRACTOR INSTALLER

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

CONFIG_FILE="./pyload-tools-config.cfg"
source $CONFIG_FILE
if [ $? = 0 ]
then
echo "+ config file loaded"
else
echo "- config file not found > aborting"
exit 1
fi

echo "checking config file"
if [ -n "$python_bin" ]
then
echo "- python_bin is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_base_dir" ]
then
echo "- pyload_base_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$log_file" ]
then
echo "- log_file is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_log_file" ]
then
echo "- pyload_log_file is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_dir" ]
then
echo "- pyload_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$dl_temp_dir" ]
then
echo "- dl_temp _ir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$dl_dir" ]
then
echo "- dl_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$dest_dir" ]
then
echo "- dest_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$move_to_nas_dir" ]
then
echo "- move_to_nas_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_script_files_dir" ]
then
echo "- pyload_script_files_dir is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$env_vars" ]
then
echo "- env_vars is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_user" ]
then
echo "- pyload_user is unset - please edit python-tools-config.cfg"
exit 1
elif [ -n "$pyload_group" ]
then
echo "- pyload_group is unset - please edit python-tools-config.cfg"
exit 1
else
echo "+ config file is ok"
fi

echo "copying files"
copyfiles() {
if [ -d "$pyload_script_files" ]
then
cp ./pyload/* $pyload_script_files_dir/ 
else
mkdir $pyload_scripts_files && cp ./pyload/* $pyload_script_files_dir/
fi

cp ./python/*.py $pyload_base_dir/
cp ./pyload-tools-config.cfg $pyload_script_files_dir/
touch $pyload_log_file
}
copyfiles;
if [ $? = 0 ]
then
echo "+ files were copied"
else
echo "-  error while copying files > aborting"
exit 1
fi

echo "setting permissions"
permissions() {
chown -R $pyload_user:$pyload_group $pyload_script_files_dir/*
chmod a+x $pyload_script_files_dir/pyload-extractor
chmod a+x $pyload_script_files_dir/pyload-extractor-file
chmod a+x $pyload_script_files_dir/pyload-include-tags
chmod a+x $pyload_script_files_dir/pyload-action-handler
chmod a+x $pyload_base_dir/pyload-getPackageID.py
chmod a+x $pyload_base_dir/pyload-getPackageName.py
chmod a+x $pyload_base_dir/pyload-getPackagePW.py
}

permissions;
if [ $? = 0 ]
then
echo "+ setting permissions done"
else
echo "- permissions could not be set > aborting"
exit 1
fi

echo "symlink pyload scripts to pyload-script folder"
symlinks() {
ln -s $pyload_script_files_dir/pyload-extractor $pyload_dir/scripts/package_finished/pyload-extractor.sh
ln -s $pyload_script_files_dir/pyload-action-handler $pyload_dir/scripts/download_finished/pyload-action-handler.sh
}
symlinks;
if [ $? = 0 ]
then
echo "+ symlinking done"
else
echo "- error wnile symlink pyload-scripts > aborting"
exit 1
fi

echo "creating env variables"
vars() {
export PYLOAD_TOOL_CFG="$pyload_script_files_dir/pyload-tools-config.cfg"
export PYLOAD_INCLUDE_TAGS="$pyload_script_files_dir/pyload-include-tags"
export PYLOAD_EXTRACTOR="$pyload_script_files_dir/pyload-extractor"
export PYLOAD_EXTRACTOR_FILE="$pyload_script_files_dir/pyload-extractor-file"
echo "PYLOAD_TOOL_CFG=\"$PYLOAD_TOOL_CFG\"" >> $env_vars
echo "PYLOAD_INCLUDE_TAGS=\"$PYLOAD_INCLUDE_TAGS\"" >> $env_vars
echo "PYLOAD_EXTRACTOR=\"$PYLOAD_EXTRACTOR\"" >> $env_vars
echo "PYLOAD_EXTRACTOR_FILE=\"$PYLOAD_EXTRACTOR_FILE\"" >> $env_vars
}
vars;
if [ $? = 0 ]
then
echo "+ creating env vars done"
else
echo "-  error wnile creating env vars > aborting"
exit 1
fi

echo "installation done > please relogin to activate env vars"
echo "after relogin enable \"external scripts plugin\" in pyload"
echo "exiting..."
exit 1
