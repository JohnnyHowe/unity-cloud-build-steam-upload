echo "Starting Steam Upload"

# Unzip the required SDK contents
python "$THIS_PATH/unzipContentBuilder.py"

# Move compiled games contents to ContentBuilder/content
rm -rf "$THIS_PATH/ContentBuilder/content"
mkdir "$THIS_PATH/ContentBuilder/content"
cp -a $OUTPUT_DIRECTORY/. "$THIS_PATH/ContentBuilder/content"

# # Insert config file
mkdir -p "$THIS_PATH/ContentBuilder/builder/config"
echo $STEAM_SDK_USER_CONFIG > "$THIS_PATH/ContentBuilder/builder/config/config.vdf"

# Create build file (and the python file to create that file)
echo "
import os 
this_path='Assets/CICD/UnityCloudBuild'

# load in template
with open(this_path + '/SteamBuildScriptTemplate.vdf', 'r') as file:
    contents = file.read()

# replace bits with environment variables
for var in ['APP_ID', 'DEPOT_ID']:
    contents = contents.replace('$' + var, os.environ[var])

# write edited
with open(this_path + '/ContentBuilder/scripts/SteamBuildScript.vdf', 'w') as file:
    file.write(contents)
" > "$THIS_PATH/CreateSteamBuildScript.py"
python "$THIS_PATH/CreateSteamBuildScript.py"

# Run the bitch
STEAM_SDK="$THIS_PATH/ContentBuilder/builder/steamcmd.exe"
echo $STEAM_SDK +login $STEAM_USER_NAME +run_app_build "..\scripts\SteamBuildScript.vdf" +quit
$STEAM_SDK +login $STEAM_USER_NAME +run_app_build "..\scripts\SteamBuildScript.vdf" +quit

# Cleanup
rm -rf $THIS_PATH/ContentBuilder
rm $THIS_PATH/CreateSteamBuildScript.py
echo "Steam Upload Complete"