# docker-adf-workshop
Latest ADF-Workshop by Crashdisk running inside a docker image

# To do
* ~~ANSI codes (verified to work with winetricks riched20 on macos)~~
* DB Update from EAB
* ~~Mountable folders~~
* ~~Beta support~~
* ~~Monospaced font to better support ASCII tables and file listings~~

# Based on
* [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui/)
* [laromicas/docker-romvault](https://github.com/laromicas/docker-romvault/)

# Apple Silicon build notes
```zsh
colima start --arch x86_64 --vm-type vz --vz-rosetta
docker-buildx build --platform linux/amd64 --build-arg ADFWORKSHOP_VERSION=beta -t adf-workshop .
docker run -p 5800:5800 -v ~/.appdata/ADF-Workshop:/config -v ~/Amiga/Floppies:/disks -e USER_ID="501" -e GROUP_ID="20" adf-workshop
```