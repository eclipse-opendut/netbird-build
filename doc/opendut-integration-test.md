## Integration test with OpenDuT

* Update `Cargo.toml`
```shell
# download netbird client release from here
netbird.repository = "https://github.com/eclipse-opendut/netbird-build"
# with the following version
netbird.version = "0.66.4-5355884422cbedd56b538b8e80ff7e7b4ef1a78c"
# and use the protobuf definition for the netbird client service daemon from here (possible separate location to be configured)
netbird.protobuf = "https://github.com/eclipse-opendut/netbird-build/releases/download/v0.66.4-5355884422cbedd56b538b8e80ff7e7b4ef1a78c/daemon.proto"
```
* Create release
```shell
cargo ci dist
```
* Configure mTLS in testenv
```shell
cp .ci/deploy/localenv/docker-compose.override.netbird-mtls.yml .ci/deploy/localenv/docker-compose.override.yml
cp .ci/deploy/testenv/edgar/docker-compose.override.mtls.yml .ci/deploy/testenv/edgar/docker-compose.override.yml
```
* Ensure services demand a client certificate
```shell
curl -k https://carl.opendut.local
curl -k https://netbird-api.opendut.local/api/groups
curl: (56) OpenSSL SSL_read: error:0A00045C:SSL routines::tlsv13 alert certificate required, errno 0
```
* And it works when client certificates are provided
```shell
curl --cert /provision/pki/deploy/edgar-leader.pem --key /provision/pki/deploy/edgar-leader.key https://carl.opendut.local
curl --cert /provision/pki/deploy/edgar-leader.pem --key /provision/pki/deploy/edgar-leader.key https://netbird-api.opendut.local/api/groups
```
* Import client certificate `.ci/deploy/localenv/data/secrets/pki/deploy/opendut-browser-client.p12` to the browser.
* And test access to carl.opendut.local and netbird-api.opendut.local
* Use secrets `.ci/deploy/localenv/data/secrets/.env` to login
* Run EDGAR test cluster
```shell
cargo theo testenv cluster start
```
