Base
====
A basic Ubuntu 16.04 container with build tools installed. It is useful as an
starting point and template for experimenting with new container definitions.
As only ~150M in size, it installs and starts quickly.


Building
--------
Build the container using the provided build script:

::

    ./base.acbuild.sh

This will make a ``base.aci`` in the directory. Install this into ``rkt``:

::

    rkt --insecure-options=image fetch ./base.aci

This container is intended for interactive use, so to run it with ``rkt`` use:

::

    sudo rkt run \
        --interactive \
        --volume containers,kind=host,source=$(pwd) \
        woofwoofinc.dog/base \
        --mount volume=containers,target=/containers

The current working directory is available on the container at ``/containers``.
