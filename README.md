# netbird-build

Build NetBird **client** for multiple architectures.

## Release workflow

* Update branch in [fork](https://github.com/eclipse-opendut/netbird-fork)
  * Current branch name is `configure-mtu2` (this contains the revised commit after the latest rebase for v0.28.9)
* Update `netbird_ref` in [workflow](.github/workflows/release.yml)
* Commit & Push
