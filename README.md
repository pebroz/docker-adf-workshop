# docker-adf-workshop
Latest ADF-Workshop by Crashdisk running inside a docker image. Application written by Crashdisk, databases by Crashdisk.
Big thanks to the Amiga and TOSEC community.

# Editions (tags)
* 0day is the latest build from the development thread over at EAB.
* beta is the latest published build on regular distribution channels.
* stable is the version published on the TOSEC homepage.

Expect some delays as I do manual mirror of some of the files, due to download restrictions.

# To do
* ~~ANSI codes (verified to work with winetricks riched20 on macos)~~
* ~~DB Update from EAB~~
* ~~Mountable folders~~
* ~~Beta support~~
* ~~Monospaced font to better support ASCII tables and file listings~~
* ~~Open file default folder~~
* Filesystem encoding issues

# Based on
* [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui/)
* [laromicas/docker-romvault](https://github.com/laromicas/docker-romvault/)

# Apple Silicon build notes
```zsh
colima start --arch x86_64 --vm-type vz --vz-rosetta
docker-buildx build --platform linux/amd64 --build-arg ADFWORKSHOP_VERSION=beta -t techcf/adf-workshop:0day .
docker run -p 5800:5800 -v ~/.appdata/ADF-Workshop:/config -v ~/Amiga/Floppies:/disks -e USER_ID="501" -e GROUP_ID="20" techcf/adf-workshop:0day
```