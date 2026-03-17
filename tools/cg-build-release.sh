#!/bin/bash
set -e

VERSION="${1}"
if [[ -z "$VERSION" ]]; then
    echo "Usage: $0 VERSION" >&2
    exit 1
fi

echo "Cleaning previous builds..."
rm -rf release-v*.tgz release-v*-x86_64/
rm -rf build/cargo_target/x86_64-unknown-linux-musl/release/firecracker
rm -rf build/cargo_target/x86_64-unknown-linux-musl/release/jailer

echo "Building with devtool..."
tools/devtool build --release

# This is optional
# echo "Stripping binaries..."
# strip build/cargo_target/x86_64-unknown-linux-musl/release/firecracker
# strip build/cargo_target/x86_64-unknown-linux-musl/release/jailer

echo "Packaging release..."
mkdir -p "release-v${VERSION}-x86_64"

cp build/cargo_target/x86_64-unknown-linux-musl/release/firecracker "release-v${VERSION}-x86_64/firecracker-v${VERSION}-x86_64"

cp build/cargo_target/x86_64-unknown-linux-musl/release/jailer "release-v${VERSION}-x86_64/jailer-v${VERSION}-x86_64"

cp src/api_server/swagger/firecracker.yaml "release-v${VERSION}-x86_64/firecracker_spec-v${VERSION}.yaml"

cp LICENSE NOTICE THIRD-PARTY "release-v${VERSION}-x86_64/"

tar -czvf "firecracker-v${VERSION}-x86_64.tgz" "release-v${VERSION}-x86_64/"
