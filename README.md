# flutter_development_container

# WIP do not use!!!

### a container for flutter development 

inspired by [docker-flutter][docker-flutter#link], [flutter-dev-container][flutter-dev-container#link] and [docker-android-sdk][docker-android-sdk#link]\
but based on [podman][podman#link] & [buildah-build][buildah-build#link] instead of `docker`

### setup

<details>
<summary> arch linux</summary>

```console
yes "y" | sudo pacman -Syyu && \
yes "y" |sudo pacman -S podman
```
</details>

### TODO

- complete publish workflow with [push-to-registry][push-to-registry#link]
- replace `vim` with [lunar-vim][lunar-vim#link] and set it up as IDE

[docker-flutter#link]: https://github.com/matsp/docker-flutter
[flutter-dev-container#link]: https://github.com/lucashilles/flutter-dev-container
[fvm#link]: https://github.com/leoafarias/fvm
[buildah#link]: https://github.com/containers/buildah
[podman#link]: https://github.com/containers/podman
[buildah-build#link]: https://github.com/marketplace/actions/buildah-build
[push-to-registry#link]: https://github.com/marketplace/actions/push-to-registry
[docker-android-sdk#link]:https://github.com/docker-android-sdk/android-29/blob/master/Dockerfile
[lunar-vim#link]:https://github.com/LunarVim/LunarVim
