Qompass Implementation of Python 3.14.0 alpha 0
=====================================

# Qompass CPython Compilation of Python 3.14 without Global Interpreter Lock (GIL)
- Disclaimer: The Python Foundation has made clear that compiling CPython without the GIL is experimental. By extension, this is not something we recommend inexperienced developers do. Any system errors that occur as a result of following these instructions are done at the risk of the user.

# Arch Linux
First, ensure you have the necessary build tools installed:
```bash
sudo pacman -S base-devel git
```
Clone the CPython repository:
```bash
git clone https://github.com/python/cpython.git
cd cpython
```
Configure the build with the --disable-gil and --enable-optimizations option and set the installation prefix to /opt/python3.14:
```bash
./configure --disable-gil  --enable-optimizations --prefix=/opt/python3.14
```
Compile CPython:
```bash
make -j$(nproc)
```
Install the compiled version:
```bash
sudo make install
```

## Open your ~/.bashrc file in a text editor:
```
nvim ~/.bashrc
```
Add the following line at the end of the file:
```
alias p3.14='/opt/python3.14/bin/python3'
```
- Save the file and exit the editor (in nano, press Ctrl+X, then Y, then Enter).To apply the changes immediately, source your .bashrc file:
```bash
source ~/.bashrc
```
- Now you can use p3.14 to run your custom Python version from anywhere in the terminal:
```bash
$ p3.14
Python 3.14.0a0 experimental free-threading build (heads/main:540fcc62f5, Aug  7 2024, 16:32:25) [GCC 14.2.1 20240805] on linux
Type "help", "copyright", "credits" or "license" for more information.
```
- This will start the Python interpreter, or you can run scripts with:
```
p3.14 your_script.py
```


## Ubuntu 24.04

1. Install build dependencies:
   ```bash
   sudo apt update
   sudo apt install build-essential git
   ```
2.
```bash
git clone https://github.com/python/cpython.git
cd cpython
```

3.
```bash
./configure --disable-gil --enable-optimizations --prefix=/opt/python3.14
make -j$(nproc)
sudo make install
```
4. Set up alias
```echo "alias p3.14='/opt/python3.14/bin/python3'" >> ~/.bashrc
source ~/.bashrc
```

5. Run the new python
```bash
p3.14
```

## macOS
- Install Xcode Command Line Tools and Homebrew:
```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
- Install dependencies:
```bash
brew install openssl readline sqlite3 xz zlib
```
Clone and build CPython:
```bash
git clone https://github.com/python/cpython.git
cd cpython
./configure --disable-gil --prefix=/usr/local/opt/python3.14 --with-openssl=$(brew --prefix openssl)
make -j$(sysctl -n hw.ncpu)
sudo make install
```
- Set up alias:
```bash
echo "alias p3.14='/usr/local/opt/python3.14/bin/python3'" >> ~/.zshrc
source ~/.zshrc
```
Run the new Python:
```bash
p3.14
```
## Windows 11 with WSL2 (Ubuntu 24.04)

1. Install WSL2 and Ubuntu 24.04:
   Open PowerShell as Administrator and run:
   ```powershell
   wsl --install -d Ubuntu-24.04
   ```
2. Follow Ubuntu 24.04 instructions

# Remainder of this README is boilerplate from the home repo https://github.com/cython/cython
Copyright © 2001-2024 Python Software Foundation.  All rights reserved.

General Information
-------------------

- Website: https://www.python.org
- Source code: https://github.com/python/cpython
- Issue tracker: https://github.com/python/cpython/issues
- Documentation: https://docs.python.org
- Developer's Guide: https://devguide.python.org/



Using Python
------------

Installable Python kits, and information about using Python, are available at
`python.org`.

python.org: https://www.python.org/

Build Instructions
------------------

On Unix, Linux, BSD, macOS, and Cygwin::

    ./configure
    make
    make test
    sudo make install

This will install Python as ``python3``.

You can pass many options to the configure script; run ``./configure --help``
to find out more.  On macOS case-insensitive file systems and on Cygwin,
the executable is called ``python.exe``; elsewhere it's just ``python``.

Building a complete Python installation requires the use of various
additional third-party libraries, depending on your build platform and
configure options.  Not all standard library modules are buildable or
useable on all platforms.  Refer to the
`Install dependencies <https://devguide.python.org/getting-started/setup-building.html#build-dependencies>`_
section of the `Developer Guide`_ for current detailed information on
dependencies for various Linux distributions and macOS.

On macOS, there are additional configure and build options related
to macOS framework and universal builds.  Refer to `Mac/README.rst
<https://github.com/python/cpython/blob/main/Mac/README.rst>`_.

On Windows, see `PCbuild/readme.txt
<https://github.com/python/cpython/blob/main/PCbuild/readme.txt>`_.

To build Windows installer, see `Tools/msi/README.txt
<https://github.com/python/cpython/blob/main/Tools/msi/README.txt>`_.

If you wish, you can create a subdirectory and invoke configure from there.
For example::

    mkdir debug
    cd debug
    ../configure --with-pydebug
    make
    make test

(This will fail if you *also* built at the top-level directory. You should do a ``make clean`` at the top-level first.)

To get an optimized build of Python, ``configure --enable-optimizations``
before you run ``make``.  This sets the default make targets up to enable
Profile Guided Optimization (PGO) and may be used to auto-enable Link Time
Optimization (LTO) on some platforms.  For more details, see the sections
below.

Profile Guided Optimization
^^^^^^^^^^^^^^^^^^^^^^^^^^^

PGO takes advantage of recent versions of the GCC or Clang compilers.  If used,
either via ``configure --enable-optimizations`` or by manually running
``make profile-opt`` regardless of configure flags, the optimized build
process will perform the following steps:

The entire Python directory is cleaned of temporary files that may have
resulted from a previous compilation.

An instrumented version of the interpreter is built, using suitable compiler
flags for each flavor. Note that this is just an intermediary step.  The
binary resulting from this step is not good for real-life workloads as it has
profiling instructions embedded inside.

After the instrumented interpreter is built, the Makefile will run a training
workload.  This is necessary in order to profile the interpreter's execution.
Note also that any output, both stdout and stderr, that may appear at this step
is suppressed.

The final step is to build the actual interpreter, using the information
collected from the instrumented one.  The end result will be a Python binary
that is optimized; suitable for distribution or production installation.


Link Time Optimization

Enabled via configure's ``--with-lto`` flag.  LTO takes advantage of the
ability of recent compiler toolchains to optimize across the otherwise
arbitrary ``.o`` file boundary when building final executables or shared
libraries for additional performance gains.


What's New
----------

We have a comprehensive overview of the changes in the `What's New in Python
3.14 <https://docs.python.org/3.14/whatsnew/3.14.html>`_ document.  For a more
detailed change log, read `Misc/NEWS
<https://github.com/python/cpython/tree/main/Misc/NEWS.d>`_, but a full
accounting of changes can only be gleaned from the `commit history
<https://github.com/python/cpython/commits/main>`_.

If you want to install multiple versions of Python, see the section below
entitled "Installing multiple versions".


Documentation
-------------

`Documentation for Python 3.14 <https://docs.python.org/3.14/>`_ is online,
updated daily.

It can also be downloaded in many formats for faster access.  The documentation
is downloadable in HTML, PDF, and reStructuredText formats; the latter version
is primarily for documentation authors, translators, and people with special
formatting requirements.

For information about building Python's documentation, refer to `Doc/README.rst
<https://github.com/python/cpython/blob/main/Doc/README.rst>`_.


Testing
-------

To test the interpreter, type ``make test`` in the top-level directory.  The
test set produces some output.  You can generally ignore the messages about
skipped tests due to optional features which can't be imported.  If a message
is printed about a failed test or a traceback or core dump is produced,
something is wrong.

By default, tests are prevented from overusing resources like disk space and
memory.  To enable these tests, run ``make buildbottest``.

If any tests fail, you can re-run the failing test(s) in verbose mode.  For
example, if ``test_os`` and ``test_gdb`` failed, you can run::

    make test TESTOPTS="-v test_os test_gdb"

If the failure persists and appears to be a problem with Python rather than
your environment, you can `file a bug report
<https://github.com/python/cpython/issues>`_ and include relevant output from
that command to show the issue.

See `Running & Writing Tests <https://devguide.python.org/testing/run-write-tests.html>`_
for more on running tests.

Installing multiple versions
----------------------------

On Unix and Mac systems if you intend to install multiple versions of Python
using the same installation prefix (``--prefix`` argument to the configure
script) you must take care that your primary python executable is not
overwritten by the installation of a different version.  All files and
directories installed using ``make altinstall`` contain the major and minor
version and can thus live side-by-side.  ``make install`` also creates
``${prefix}/bin/python3`` which refers to ``${prefix}/bin/python3.X``.  If you
intend to install multiple versions using the same prefix you must decide which
version (if any) is your "primary" version.  Install that version using
``make install``.  Install all other versions using ``make altinstall``.

For example, if you want to install Python 2.7, 3.6, and 3.14 with 3.14 being the
primary version, you would execute ``make install`` in your 3.14 build directory
and ``make altinstall`` in the others.


Release Schedule
----------------

See `PEP 745 <https://peps.python.org/pep-0745/>`__ for Python 3.14 release details.


Copyright and License Information
---------------------------------


Copyright © 2001-2024 Python Software Foundation.  All rights reserved.

Copyright © 2000 BeOpen.com.  All rights reserved.

Copyright © 1995-2001 Corporation for National Research Initiatives.  All
rights reserved.

Copyright © 1991-1995 Stichting Mathematisch Centrum.  All rights reserved.

See the `LICENSE <https://github.com/python/cpython/blob/main/LICENSE>`_ for
information on the history of this software, terms & conditions for usage, and a
DISCLAIMER OF ALL WARRANTIES.

This Python distribution contains *no* GNU General Public License (GPL) code,
so it may be used in proprietary projects.  There are interfaces to some GNU
code but these are entirely optional.

All trademarks referenced herein are property of their respective holders.