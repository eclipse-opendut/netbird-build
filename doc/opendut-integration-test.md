# Integration test with OpenDuT

## Test NetBird client release in OpenDuT

* Update `Cargo.toml`
```shell
# download netbird client release from here
netbird.repository = "https://github.com/eclipse-opendut/netbird-build"
# with the following version
netbird.version = "0.66.4-5355884422cbedd56b538b8e80ff7e7b4ef1a78c"
# and use the protobuf definition for the netbird client service daemon from here (possible separate location to be configured)
netbird.protobuf = "https://github.com/eclipse-opendut/netbird-build/releases/download/v0.66.4-5355884422cbedd56b538b8e80ff7e7b4ef1a78c/daemon.proto"
```
* Update `Cargo.toml` with sed
```shell
# omit "v" prefix
export NETBIRD_VERSION=0.67.1-e6333229d8f37878c248906b9f11fd6ba3c29e11
sed -i "s#netbird.repository = .*#netbird.repository = \"https://github.com/eclipse-opendut/netbird-build\"#" Cargo.toml
sed -i "s#netbird.version = .*#netbird.version = \"$NETBIRD_VERSION\"#" Cargo.toml
sed -i "s#netbird.protobuf = .*#netbird.protobuf = \"https://github.com/eclipse-opendut/netbird-build/releases/download/v$NETBIRD_VERSION/daemon.proto\"#" Cargo.toml
```

* Create release with updated NetBird client
```shell
cargo ci dist --release
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

## Manually test NetBird client release

* Install opendut ca certificate
```shell
cp /provision/pki/opendut-ca.pem /usr/local/share/ca-certificates/opendut-ca.crt
update-ca-certificates
```

* Start NetBird client
```shell
netbird service install
netbird service start
```
* Create NetBird client profile
```shell
netbird profile add mTLS
netbird profile list
cat /var/lib/netbird/root/mTLS.json
grep -i cert -A2 /var/lib/netbird/root/mTLS.json
netbird profile select mTLS
```

* Update NetBird client certificate paths
```shell
apt install -y moreutils
jq '.MgmtClientCert.CertPath = "/provision/pki/deploy/edgar-leader.pem"' /var/lib/netbird/root/mTLS.json | sponge /var/lib/netbird/root/mTLS.json
jq '.MgmtClientCert.KeyPath = "/provision/pki/deploy/edgar-leader.key"' /var/lib/netbird/root/mTLS.json | sponge /var/lib/netbird/root/mTLS.json
grep -i cert -A2 /var/lib/netbird/root/mTLS.json
```
* Cat certificate/key without new lines
```shell
cat /provision/pki/deploy/edgar-leader.pem | tr '\n' ' '
cat /provision/pki/deploy/edgar-leader.key | tr '\n' ' '
```
* Restart NetBird client
```
netbird service restart
tail -f /var/log/netbird/client.log
```
```shell
netbird up --management-url https://netbird-api.opendut.local/api --mtu 1542 --setup-key <TBD>
```
