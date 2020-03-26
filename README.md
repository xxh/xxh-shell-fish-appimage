### Note! Fish AppImage is unstable and we recommend to use [xxh-shell-fish](https://github.com/xxh/xxh-shell-fish)


[Xxh](https://github.com/xxh/xxh) entrypoint for fish shell appimage. Help wanted for testing and improvement.

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
xxh yourhost +s xxh-shell-fish-appimage +if
```
To avoid adding `+s` every time use xxh config `~/.xxh/.xxhc`:
```
hosts:
  ".*":                             # Regex pattern means any host
    +s: xxh-shell-fish-appimage
```
After this you could do `xxh myhost` without arguments.

## Related 
* [fish-shell / Publish AppImage](https://github.com/fish-shell/fish-shell/issues/6475)
* [fish-shell / Portable fish shell](https://github.com/fish-shell/fish-shell/issues/3095)
* [Download fish AppImage](https://download.opensuse.org/repositories/shells:/fish:/nightly:/master/AppImage/)

## Thanks
* @probonopd for https://github.com/AppImage
