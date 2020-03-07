Xxh entrypoint for fish shell appimage. 

## Install
Install [xxh](https://github.com/xxh/xxh) and run `xxh --help` once and then:
```
cd ~/.xxh/xxh/shells/
git clone https://github.com/xxh/xxh-shell-fish-appimage
./xxh-shell-fish-appimage/build.xsh
xxh myhost +s xxh-fish-xonsh-appimage
```
To avoid adding `+s` every time use xxh config `~/.xxh/.xxhc`:
```
hosts:
  ".*":                             # Regex pattern means any host
    +s: xxh-fish-xonsh-appimage
```
After this you could do `xxh myhost` without arguments.

## Related 
* [fish-shell / Publish AppImage](https://github.com/fish-shell/fish-shell/issues/6475)
* [fish-shell / Portable fish shell](https://github.com/fish-shell/fish-shell/issues/3095)
* [Download fish AppImage](https://download.opensuse.org/repositories/shells:/fish:/nightly:/master/AppImage/)