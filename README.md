<p align="center">
<b>Note!</b> <a href="https://github.com/fish-shell/fish-shell/issues/6475">Fish AppImage is unstable</a> and we recommend to use <a href="https://github.com/xxh/xxh-shell-fish">xxh-shell-fish</a>
</p>

<p align="center">
<b>xxh-shell-fish-appimage</b> is an <a href="https://github.com/xxh/xxh">xxh</a> entrypoint for fish shell AppImage. Help wanted for testing and improvement.
</p>

## Install
Install from xxh repo:
```
xxh +I xxh-shell-fish-appimage
```
Install from any repo:
```
xxh +I xxh-shell-fish-appimage+git+https://github.com/xxh/xxh-shell-fish-appimage
```
Connect:
``` 
xxh yourhost +s fish-appimage +if
```
To avoid adding `+s` every time use xxh config `~/.config/xxh/config.xxhc` (`$XDG_CONFIG_HOME`):
```
hosts:
  ".*":                             # Regex pattern means any host
    +s: fish-appimage
```
After this you could do `xxh myhost` without arguments.

## Related 
* [fish-shell / Publish AppImage](https://github.com/fish-shell/fish-shell/issues/6475)
* [fish-shell / Portable fish shell](https://github.com/fish-shell/fish-shell/issues/3095)
* [Download fish AppImage](https://download.opensuse.org/repositories/shells:/fish:/nightly:/master/AppImage/)

## Thanks
* @probonopd for https://github.com/AppImage
