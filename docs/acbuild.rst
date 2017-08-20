acbuild
-------
The acbuild_ tool is a command line interface for building ACI containers. The
rkt documentation contains a guide on `Building an App Container image`_ based
on using acbuild.

.. _acbuild: https://github.com/containers/build
.. _Building an App Container image: https://coreos.com/rkt/docs/latest/trying-out-rkt.html#building-an-app-container-image


Building Containers with acbuild
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The `acbuild documentation`_ contains detailed information on using the tool.
In particular, see the `acbuild Getting Started guide`_ and
`acbuild subcommand documentation`_.

.. _acbuild documentation: https://github.com/containers/build/blob/master/README.md
.. _acbuild Getting Started guide: https://github.com/containers/build/blob/master/Documentation/getting-started.md
.. _acbuild subcommand documentation: https://github.com/containers/build/tree/master/Documentation/subcommands

This repository also contains build script examples illustrating how to use
``acbuild`` to make a variety of containers for development use.

.. CAUTION::
   Most services do not default to listening to all network interfaces. Instead
   they typically just listed on the local ``localhost`` network. This is a
   problem when specifying a service to run inside a container because the
   ``localhost`` network on the container will not be available outside of the
   container. This means we cannot access the container service from our host
   computer.

   Most services have command line options to change the network interface on
   which the service listens. Usually, it is sufficient to change this to be
   the ``0.0.0.0`` interface, i.e. listen on all network interfaces on the
   container. This will then include the external network interface which our
   host computer will use to attempt to connect to the container.


.. _acbuild-tutorial:

Tutorial
~~~~~~~~
We take the example of creating a container for Jupyter_. Jupyter is the
notebooking system which was previously called iPython Notebook before being
extended to incorporate other backends.

.. _Jupyter: http://jupyter.org

The acbuild command uses hidden directories in the current working directory as
part of the build, so it is necessary to create a directory for each new
container build.

::

    mkdir -p jupyter
    cd jupyter

.. _acbuild: https://github.com/containers/build

Containers need to be created from a base image. For this example, we download
a Ubuntu base image.

::

    wget http://cdimage.ubuntu.com/ubuntu-base/releases/17.04/release/ubuntu-base-17.04-base-amd64.tar.gz

Once this is finished, we begin the container construction by specifying this
base image and giving the container a name. This name in used in rkt when
listing running containers.

.. NOTE::
   Superuser privileges are needed to run ``acbuild`` commands. It is useful to
   setuid ``root`` on the ``acbuild`` executable. The ``sudo`` prefix to
   ``acbuild`` commands will be omitted below.

::

    acbuild begin ./ubuntu-base-17.04-base-amd64.tar.gz
    acbuild set-name woofwoofinc.dog/jupyter

This creates the basic layout of the container. The ``acbuild`` command has
subcommands which add and perform operations on the base image. A full list can
be seen by running ``acbuild --help``.

We will mainly use the ``acbuild run`` subcommand. This loads the container in
its current state and performs a command from within the container. We use this
to run ``apt`` and other installation instructions on the container itself.

Begin by updating the Ubuntu base installation and adding ``wget`` and
``bzip2`` which are needed for later steps in the installation.

::

    acbuild run -- apt-get update -qq
    acbuild run -- apt-get upgrade -qq
    acbuild run -- apt-get install -qq wget bzip2

Next, we perform the Jupyter installation steps. Since we are primarily
interested in creating containers, we'll skip through the actual Jupyter
installation itself quickly.

(For the interested, Jupyter is installed by first installing the miniconda_
minimal distribution of Anaconda_, a Python data science platform, and then
using the Anaconda package manager to install the rest of the parts.)

.. _miniconda: https://conda.io/miniconda.html
.. _Anaconda: https://www.continuum.io

::

    acbuild run -- wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    acbuild run -- bash Miniconda3-latest-Linux-x86_64.sh -b -p /usr -f
    acbuild run -- rm -fr Miniconda3-latest-Linux-x86_64.sh
    acbuild run -- conda install -y numpy matplotlib pandas scikit-learn jupyter
    acbuild run -- mkdir -p /home/jupyter

To be able to use the Jupyter service from a host machine, we need to make the
port it uses available externally. This is done by specifying the ports which
should be accessible on the container.

Jupyter will run on port 80, so make this available outside the container.

::

    acbuild port add http tcp 80

Next, set a command for the container to run when it starts. This uses a
permissive Jupyter run line so do not use this container outside of a secure
environment.

::

    acbuild set-exec -- \
        jupyter notebook --no-browser --allow-root --ip='*' --port=80 --notebook-dir=/home/jupyter --NotebookApp.token=''

And finally, clean the container image to save space.

::

    acbuild run -- apt-get -qq autoremove
    acbuild run -- apt-get -qq clean

We can create the container image file now using ``acbuild write``. This
exports the container layout from the current directory build into a ACI format
container file which can be imported into rkt.

::

    acbuild write --overwrite jupyter.aci

On success there will be a file name ``jupyter.aci`` in the current directory.
Finish the container build by telling ``acbuild`` to clean up the hidden
directories it created during the build.

::

    acbuild end
