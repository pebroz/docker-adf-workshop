# docker-adf-workshop
Latest ADF-Workshop by Crashdisk running inside a docker image

# To do
* ANSI codes (verified to work with winetricks riched20 on macos)
* DB Update from EAB
* Mountable folders
* ~~Beta support~~

# Based on
* [jlesage/docker-baseimage-gui](https://github.com/jlesage/docker-baseimage-gui/)
* [laromicas/docker-romvault](https://github.com/laromicas/docker-romvault/)

# Apple Silicon build notes
colima start --arch x86_64 --vm-type vz --vz-rosetta
docker-buildx build --platform linux/amd64 --build-arg ADFWORKSHOP_VERSION=beta -t adf-workshop .