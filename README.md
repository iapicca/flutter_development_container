# flutter_development_container

# WIP do not use!!!

### a container for flutter development 

inspired by [docker-flutter][docker-flutter#link] and [flutter-dev-container][flutter-dev-container#link]
but based on [podman][podman#link] instead of `docker`

### setup

<details>
<summary> arch linux</summary>

```console
yes "y" | sudo pacman -Syyu \
&& yes "y" |sudo pacman -S podman
```
</details>

### what's next?

- use [fvm][fvm#link] instead of curl flutter directly 
- better setup (more operative system and distros)

#

the container image is built with [buildah][buildah#link] using [buildah-build][buildah-build#link] github action
to install buildah locally follow the steps below (only supports linux)


<details>
<summary> arch linux</summary>

```console
yes "y" | sudo pacman -Syyu \
&& yes "y" |sudo pacman -S buildah 
```
</details>


[docker-flutter#link]: https://github.com/matsp/docker-flutter
[flutter-dev-container#link]: https://github.com/lucashilles/flutter-dev-container
[fvm#link]: https://github.com/leoafarias/fvm
[buildah#link]: https://github.com/containers/buildah
[podman#link]: https://github.com/containers/podman
[buildah-build#link]: https://github.com/marketplace/actions/buildah-build

