echo "Starting Steam Upload"

# Unzip the required SDK contents
echo "
import zipfile;
with zipfile.ZipFile('$BUILD_SCRIPT_PATH/ContentBuilder.zip', 'r') as zip_ref:
    zip_ref.extractall('$BUILD_SCRIPT_PATH')
" > "$BUILD_SCRIPT_PATH/unzipper.py"
python $BUILD_SCRIPT_PATH/unzipper.py
rm $BUILD_SCRIPT_PATH/unzipper.py

# Move compiled games contents to ContentBuilder/content
rm -rf "$BUILD_SCRIPT_PATH/ContentBuilder/content"
mkdir "$BUILD_SCRIPT_PATH/ContentBuilder/content"
cp -a $OUTPUT_DIRECTORY/. "$BUILD_SCRIPT_PATH/ContentBuilder/content"

# Insert config file
mkdir -p "$BUILD_SCRIPT_PATH/ContentBuilder/builder/config"
echo $STEAM_SDK_USER_CONFIG > "$BUILD_SCRIPT_PATH/ContentBuilder/builder/config/config.vdf"

# Create build file (and the python file to create that file)
echo "
import os 

# load in template
with open('$BUILD_SCRIPT_PATH/SteamBuildScriptTemplate.vdf', 'r') as file:
    contents = file.read()

# replace bits with environment variables
for var in ['APP_ID', 'DEPOT_ID']:
    contents = contents.replace('$' + var, os.environ[var])

# write edited
with open('$BUILD_SCRIPT_PATH/ContentBuilder/scripts/SteamBuildScript.vdf', 'w') as file:
    file.write(contents)
" > "$BUILD_SCRIPT_PATH/CreateSteamBuildScript.py"
python "$BUILD_SCRIPT_PATH/CreateSteamBuildScript.py"

# Run the bitch
STEAM_SDK="$BUILD_SCRIPT_PATH/ContentBuilder/builder/steamcmd.exe"
echo $STEAM_SDK +login $STEAM_USER_NAME +run_app_build "..\scripts\SteamBuildScript.vdf" +quit
$STEAM_SDK +login $STEAM_USER_NAME +run_app_build "..\scripts\SteamBuildScript.vdf" +quit

# Cleanup
rm -rf $BUILD_SCRIPT_PATH/ContentBuilder
rm $BUILD_SCRIPT_PATH/CreateSteamBuildScript.py
echo "Steam Upload Complete"