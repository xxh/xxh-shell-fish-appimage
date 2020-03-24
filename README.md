[Xxh](https://github.com/xxh/xxh) entrypoint for fish shell appimage. Help wanted for testing and improvement.

## Install
Install [xxh](https://github.com/xxh/xxh) and run `xxh --help` once and then:
```
xxh +I xxh-shell-fish-appimage
xxh myhost +s xxh-shell-fish-appimage
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
