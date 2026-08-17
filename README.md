# netbird-build

Build NetBird **client** for multiple architectures.

## Release workflow

* Determine latest [NetBird release](https://github.com/netbirdio/netbird/releases)
* Update branch in [fork](https://github.com/eclipse-opendut/netbird-fork)
  * See [branches](https://github.com/eclipse-opendut/netbird-fork/branches)
* Update workflos:
  * release [workflow](.github/workflows/release.yml)
  * integration [workflow](.github/workflows/opendut-integration.yml)
    * `netbird_ref`: commit hash in netbird fork repository
    * `netbird_version` used for tag
    * `GORELEASER_VERSION` used for goreleaser action
    * Ensure actual commands in test and release workflow are up to date with the upstream repository
* Commit & Push

### Example workflow

Example workflow for NetBird release [v0.77.0](https://github.com/netbirdio/netbird/releases/tag/v0.77.0) and mTLS patch:
- Related NetBird pull request: [[client] Add client-side support for mTLS](https://github.com/netbirdio/netbird/pull/5416)

Configured git remotes:
```
reimar@laptop:~/projects/opendut/netbird$ git remote -v
eclipse git@github.com:eclipse-opendut/netbird-fork.git (fetch)
eclipse git@github.com:eclipse-opendut/netbird-fork.git (push)
mb-netbird      git@github.com:mercedes-benz/netbird.git (fetch)
mb-netbird      git@github.com:mercedes-benz/netbird.git (push)
upstream        https://github.com/netbirdio/netbird/ (fetch)
upstream        https://github.com/netbirdio/netbird/ (push)
```

#### CI

1. Update branch in fork:
    ```
    cd ~/projects/opendut/netbird/
    git checkout -b 424-mtls-for-netbird-client-v0.77.0
    git rebase -i upstream/main
    # fix conflicts, if any
    # git push -u eclipse 424-mtls-for-netbird-client-v0.77.0
    # git push --force-with-lease
    ```
2. Determine variables for release workflow:
    ```shell
    ./scripts/determine-variables.sh
    ```
3. Update test and release [workflow](.github/workflows/release.yml)
   * `netbird_ref`: commit hash in netbird fork repository
   * `netbird_version` used for tag
   * `GORELEASER_VERSION` used for goreleaser action
4. Update integration [workflow](.github/workflows/opendut-integration.yml) with the same variables
5. Ensure actual commands in test and release workflow are up to date with the upstream repository
   * [NetBird release workflow](https://github.com/netbirdio/netbird/blob/main/.github/workflows/release.yml)

