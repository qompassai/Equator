# TuxType
## Prerequisites

Before building TuxType from source, ensure you have the following packages installed on your WSL2 Arch Linux:

```bash
sudo pacman -S base-devel git sdl sdl_image sdl_mixer sdl_ttf sdl_pango libpng libjpeg-turbo libvorbis
```
**Where you see "user", enter your own user name**
- First, create the directory and settings file if they don't exist:
```bash
mkdir -p /home/user/.tuxtype
touch /home/user/.tuxtype/settings.txt

Then, edit the settings file to specify a smaller window size:
```bash
echo "[General]
window_width=1024
window_height=768
fullscreen=0" > /home/user/.tuxtype/settings.txt
```
- This sets the window size to 1024x768 and explicitly disables fullscreen mode. You can adjust these values as needed.
- Make sure the file has the correct permissions:
```bash
sudo chmod 644 /home/user/.tuxtype/settings.txt
```
- Let's configure the build
```bash
./configure
make
```
After making these changes, try running Tux Typing again:
```bash
tuxtype
```
