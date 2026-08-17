#!/bin/bash

cd ~/projects/opendut/netbird/


netbird_ref=$(git show HEAD --pretty=format:"%H" --no-patch)
netbird_version=$(git describe --tags | grep -Eo 'v[0-9]+.[0-9]+.[0-9]+')
netbird_goreleaser_version=$(grep -E "^\s*GORELEASER" .github/workflows/release.yml | grep -Eo 'v[0-9]+.[0-9]+.[0-9]+')
opendut_version=$(curl -s https://api.github.com/repos/eclipse-opendut/opendut/releases/latest  | jq -r '.name')
netbird_version_without_v=$(echo "$netbird_version" | sed 's/^v//')
go_version=$(grep -Eo "^go [0-9]+.[0-9]+.*" go.mod | grep -Eo "[0-9]+.*")
netbird_protobuf_version=$(grep -E '//\s+protoc\s+' client/proto/daemon.pb.go | grep -Eo "v[0-9]+.[0-9]+.*" | sed -E 's/v[0-9]+\.//g')

echo "Release workflow needs:"
echo "  netbird_ref: \"$netbird_ref\""
echo "  netbird_version: \"$netbird_version\""
echo "  netbird_goreleaser_version: \"$netbird_goreleaser_version\""

echo -e "\nIntegration workflow needs:"
echo "  netbird_combined_version: \"$netbird_version_without_v-$netbird_ref\""
echo "  opendut_version: \"$opendut_version\""

echo -e "\nVirtual machine test setup"
echo "  go_version: \"$go_version\""
echo "  netbird_protobuf_version: \"$netbird_protobuf_version\""
