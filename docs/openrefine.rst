OpenRefine
==========
OpenRefine_ is a data cleaning application. This container provides a running
version of the web application.

.. _OpenRefine: http://openrefine.org


Building
--------
Build the container using the provided build script:

::

    ./openrefine.acbuild.sh

This will make a ``openrefine.aci`` in the directory. Install this into ``rkt``:

::

    rkt --insecure-options=image fetch ./openrefine.aci

This container is not intended for interactive use, so to run it with ``rkt``
use:

::

    sudo rkt run \
      --port=openrefine:3333 \
      woofwoofinc.dog/openrefine

The OpenRefine web application will be available on port 3333 of the running
host once ``rkt`` starts the container.
