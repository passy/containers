#!/usr/bin/env bash

set -xe


################################################################################
# Setup
################################################################################

mkdir -p zookeeper
pushd zookeeper > /dev/null


################################################################################
# Download Base Image
################################################################################

wget http://cdimage.ubuntu.com/ubuntu-base/releases/16.04/release/ubuntu-base-16.04.3-base-amd64.tar.gz


################################################################################
# Start Image Build
################################################################################

acbuild begin ./ubuntu-base-16.04.3-base-amd64.tar.gz
acbuild set-name woofwoofinc.dog/zookeeper


################################################################################
# Basic Development Tools
################################################################################

acbuild run -- apt-get update -qq
acbuild run -- apt-get upgrade -qq

acbuild run -- apt-get install -qq wget
acbuild run -- apt-get install -qq build-essential
acbuild run -- apt-get install -qq git


################################################################################
# Java
################################################################################

acbuild run -- apt-get install -qq openjdk-8-jre-headless


################################################################################
# Apache Bigtop
################################################################################

acbuild run -- apt-key adv --keyserver hkp://pgp.mit.edu --recv-keys 13971DA39475BD5D

acbuild run -- wget -q https://www.apache.org/dist/bigtop/bigtop-1.2.0/repos/ubuntu16.04/bigtop.list
acbuild run -- mv bigtop.list /etc/apt/sources.list.d

acbuild run -- apt-get update -qq


################################################################################
# Zookeeper
################################################################################

# Need to pin the zookeeper version to the Bigtop version number or apt will
# install from the Ubuntu repositories instead.
acbuild run -- apt-get install -qq zookeeper=3.4.6-1


################################################################################
# Set Image Executable
################################################################################

acbuild port add zookeeper tcp 2181
acbuild set-exec -- /usr/lib/zookeeper/bin/zkServer.sh start-foreground


################################################################################
# Finalise Image
################################################################################

acbuild run -- apt-get -qq autoclean
acbuild run -- apt-get -qq autoremove
acbuild run -- apt-get -qq clean

acbuild write --overwrite ../zookeeper.aci

acbuild end


################################################################################
# Cleanup
################################################################################

popd > /dev/null
rm -fr zookeeper
