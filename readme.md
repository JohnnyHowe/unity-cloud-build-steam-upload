Want to upload your build to Steam automatically from UCB? Easy peasy.
This guide assumes you've already read the official guide (https://partner.steamgames.com/doc/sdk/uploading) and are able to upload a build manually.

Technical notes:
* This is designed for a single depot to be uploaded. If you need more, then modifying the template and the script that fills the template out is what you'll need to.
* Last updated for version Steamworks SDK 1.59. Let me know if it doesn't work in newer versions and I'll update it!
# Files You'll Need
These are the important bits
* `SteamBuildUpload.sh`. This is the main script you'll set to run after the build is finished. Can be named anything really.
* `SteamBuildScriptTemplate.vdf`
* `ContentBuilder.zip`: Part of the Steamworks SDK (found in sdk > tools). Check out [ContentBuilder.zip](#contentbuilderzip)

Here's how the folder you decide to put these in will look. I've expanded out the ZIP folder view.

![Required file structure](/tutorial_images/required_files.png)
# Environment Variables
We also need to fill out some environment variables in the Unity Cloud Build advanced configuration.
* **THIS_PATH**: the folder path of this script, in my project it's at "`Assets/CICD/UnityCloudBuild`".
* **APP_ID**
* **DEPOT_ID**
* **STEAM_USER_NAME**
* **STEAM_SDK_USER_CONFIG**: the text contents of the `config.vdf` file. Checkout [config.vdf](#configvdf) on how to get this
# ContentBuilder.zip
ContentBuilder is a part of the Steamworks SDK. It contains the functionality we need to log in and upload our build, so that's all we're going to use.
To save space we're going to put a compressed version in the repo, this is the `ContentBuilder.zip` file.
(We can't download this through the script because it requires you to be logged in already, which we need the SDK for.)

To make it
1. Download the SDK (https://partner.steamgames.com/downloads/list)
2. Extract SDK somewhere
3. Navigate to SDK > tools, you should then see the `ContentBuilder` folder
4. Compress it. (On Windows 11 `right click > Compress To Zip File`)

# config.vdf
The `Config.vdf` file is how we're going to authenticate ourselves. It's a file that's created when you log in through the SDK.
Once we have it, we only need the username to log in.

**It is very important you keep this file secure**. With it someone could log in to your account in the SDK (maybe more IDK).
Because of this, we're not actually going to store it anywhere in the repo. It's just a text file that we'll put into an environment variable.

Once you've logged in to the SDK, navigate to `sdk/tools/ContentBuilder/config`. Here you should see the `config.vdf` file.
We only want the text contents, so open it up with any plain text editor and do a fat `ctrl + a` `ctrl + c`. **DO NOT SHARE THE CONTENTS WITH ANYONE. DO NOT SAVE IT ANYWHERE OTHER THAN A UCB ENVIRONMENT VARIABLE.**
# Testing Locally
We can test just the upload script by running with access to some environment variables. I did this by creating another bash script that then ran the upload one. Here it is without the variables filled out
```
# You need these for the remote build anyway
export APP_ID=
export DEPOT_ID=
export OUTPUT_DIRECTORY=
export STEAM_USER_NAME=
export STEAM_SDK_USER_CONFIG=
export THIS_PATH=

# this is a variable the UCB fills out for you, but locally we need to set it. It's just the folder path containing your build
export BUILD_PATH=

bash $THIS_PATH/PCPostBuild.sh
```
You must call this from the root of the project since that's where it will be called in UCB. So open a terminal at the root and call `$bash path/to/local_upload.sh`

**SINCE THIS FILE WILL CONTAIN THE CONTENTS OF YOUR config.vdf FILE, DO NOT ADD IT TO YOUR REPO OR SHARE IT.**