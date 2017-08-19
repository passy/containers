#!/usr/bin/env bash

set -xe


################################################################################
# Setup
################################################################################

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TMP_DIR="$(mktemp -d -p "$DIR" openrefine.XXXXXX)"
pushd "$TMP_DIR" > /dev/null


################################################################################
# Download Base Image
################################################################################

wget http://cdimage.ubuntu.com/ubuntu-base/releases/17.04/release/ubuntu-base-17.04-base-amd64.tar.gz


################################################################################
# Start Image Build
################################################################################

acbuild begin ./ubuntu-base-17.04-base-amd64.tar.gz
acbuild set-name woofwoofinc.dog/openrefine


################################################################################
# Basic Development Tools
################################################################################

acbuild run -- apt-get update -qq
acbuild run -- apt-get upgrade -qq

acbuild run -- apt-get install -qq wget


################################################################################
# Java
################################################################################

acbuild run -- apt-get install -qq openjdk-8-jre-headless


################################################################################
# OpenRefine
################################################################################

OPENREFINE_VERSION=2.7

acbuild run -- mkdir -p /opt/refine
acbuild run -- wget -q https://github.com/OpenRefine/OpenRefine/releases/download/${OPENREFINE_VERSION}/openrefine-linux-${OPENREFINE_VERSION}.tar.gz
acbuild run -- tar xzf openrefine-linux-${OPENREFINE_VERSION}.tar.gz -C /opt/refine --strip-components=1
acbuild run -- rm openrefine-linux-${OPENREFINE_VERSION}.tar.gz


################################################################################
# Set Image Executable
################################################################################

acbuild port add openrefine tcp 3333
acbuild set-exec -- /opt/refine/refine -p 3333 -i 0.0.0.0


################################################################################
# Finalise Image
################################################################################

acbuild run -- apt-get -qq autoclean
acbuild run -- apt-get -qq autoremove
acbuild run -- apt-get -qq clean

acbuild write --overwrite ../openrefine.aci

acbuild end


################################################################################
# Teardown
################################################################################

popd > /dev/null
rm -fr "$TMP_DIR"
