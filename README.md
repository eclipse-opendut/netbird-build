# netbird-build

Build NetBird **client** for multiple architectures.

## Release workflow

* Update branch in [fork](https://github.com/eclipse-opendut/netbird-fork)
* Update test and release [workflow](.github/workflows/release.yml)
  * `netbird_ref`: commit hash in netbird fork repository
  * `netbird_version` used for tag
  * `GORELEASER_VERSION` used for goreleaser action
  * Ensure actual commands in test and release workflow are up to date with the upstream repository
* Commit & Push
