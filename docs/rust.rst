Rust
====
Rust_ is a systems programming language designed for safety. Container includes
Cargo_ build tool and development plugins.

.. _Rust: https://www.rust-lang.org
.. _Cargo: http://doc.crates.io/guide.html


Building
--------
Build the container using the provided build script:

::

    ./rust.acbuild.sh

This will make a ``rust.aci`` in the directory. Install this into ``rkt``:

::

    rkt --insecure-options=image fetch ./rust.aci

This container is intended for interactive use, so to run it with ``rkt`` use:

::

    sudo rkt run \
      --interactive \
      --volume containers,kind=host,source=$(pwd) \
      woofwoofinc.dog/rust \
      --mount volume=containers,target=/containers

The current working directory is available on the container at ``/containers``.
