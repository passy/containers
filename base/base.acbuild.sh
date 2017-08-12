#!/usr/bin/env bash

set -xe


################################################################################
# Setup
################################################################################

mkdir -p base
pushd base > /dev/null


################################################################################
# Download Base Image
################################################################################

wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04.3-base-amd64.tar.gz


################################################################################
# Start Image Build
################################################################################

acbuild begin ./ubuntu-base-16.04.3-base-amd64.tar.gz
acbuild set-name woofwoofinc.dog/base


################################################################################
# Basic Development Tools
################################################################################

acbuild run -- apt-get update -qq
acbuild run -- apt-get upgrade -qq

acbuild run -- apt-get install -qq wget
acbuild run -- apt-get install -qq build-essential
acbuild run -- apt-get install -qq git


################################################################################
# Set Image Executable
################################################################################

acbuild set-exec -- /bin/bash


################################################################################
# Finalise Image
################################################################################

acbuild run -- apt-get -qq autoclean
acbuild run -- apt-get -qq autoremove
acbuild run -- apt-get -qq clean

acbuild write --overwrite ../base.aci

acbuild end


################################################################################
# Cleanup
################################################################################

popd > /dev/null
rm -fr base
