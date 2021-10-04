# flutter_development_container

a container for flutter development heavily inspired by [docker-flutter][docker-flutter#link]
but based on [buildah][buildah#link] and [podman][podman#link] instead of `docker`

### containers setup

<details>
<summary> arch linux</summary>

```console
yes "y" | sudo pacman -Syyu \
&& yes "y" |sudo pacman -S buildah \
&& yes "y" |sudo pacman -S podman
```
</details>

### what's next?

- use [fvm][fvm#link] instead of curl flutter directly 
- better setup (more operative system and distros)

[docker-flutter#link]: https://github.com/matsp/docker-flutter
[fvm#link]: https://github.com/leoafarias/fvm
[buildah#link]: https://github.com/containers/buildah
[podman#link]: https://github.com/containers/podman