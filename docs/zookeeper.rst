Zookeeper
=========
Zookeeper_ is a distributed coordination and synchronization system. This
container provides a single node test Zookeeper service.

.. _Zookeeper: https://zookeeper.apache.org

This container is useful for testing container tooling and frameworks since it
is a simple non-interactive container.


Building
--------
Build the container using the provided build script:

::

    ./zookeeper.acbuild.sh

This will make a ``zookeeper.aci`` in the directory. Install this into ``rkt``:

::

    rkt --insecure-options=image fetch ./zookeeper.aci

This container is not intended for interactive use, so to run it with ``rkt``
use:

::

    sudo rkt run \
      --port=zookeeper:2181 \
      woofwoofinc.dog/zookeeper

In order to test out this container, we use the ``rkt enter`` to get a shell
running on the container. We use this shell to start an interactive Zookeeper
session with the localhost.

List the running ``rkt`` containers and take the UUID for the Zookeeper
container just started.

::

    $ rkt list
    UUID      APP         IMAGE NAME                  STATE   CREATED         STARTED         NETWORKS
    a45b8815  zookeeper   woofwoofinc.dog/zookeeper   running 4 minutes ago   4 minutes ago   default:ip4=172.16.28.9

Here the container UUID is ``a45b8815``.

Then enter the container.

::

    sudo rkt enter a45b8815

To connect to the Zookeeper server container, run the following command. It
will use localhost as the default server.

::

    /usr/share/zookeeper/bin/zkCli.sh

The following is an example Zookeeper client session which lists the Zookeeper
keys present, the creates a new key, and fetches it to verify.

::

    [zk: 172.16.28.9:2181(CONNECTED) 0] ls /
    [zookeeper]
    [zk: 172.16.28.9:2181(CONNECTED) 1] create /woofwoofinc dogs
    Created /woofwoofinc
    [zk: 172.16.28.9:2181(CONNECTED) 2] ls /
    [zookeeper, woofwoofinc]
    [zk: 172.16.28.9:2181(CONNECTED) 3] get /woofwoofinc
    dogs
    cZxid = 0x6
    ctime = Sat Aug 12 23:48:59 UTC 2017
    mZxid = 0x6
    mtime = Sat Aug 12 23:48:59 UTC 2017
    pZxid = 0x6
    cversion = 0
    dataVersion = 0
    aclVersion = 0
    ephemeralOwner = 0x0
    dataLength = 4
    numChildren = 0
    [zk: 172.16.28.9:2181(CONNECTED) 4] quit
