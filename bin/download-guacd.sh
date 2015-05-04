#!/bin/sh -e
#
# Copyright (C) 2015 Glyptodon LLC
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

#
# download-guacd.sh: Downloads and builds guacamole-server.
#

VERSION="$1"
BUILD_DIR="/tmp"

where_is_freerdp() {
    dirname `rpm -ql freerdp-devel | grep 'libfreerdp.*\.so' | head -n1`
}

#
# Download latest guacamole-server
#

curl -L "http://sourceforge.net/projects/guacamole/files/current/source/guacamole-server-$VERSION.tar.gz" | tar -xz -C "$BUILD_DIR"

#
# Build guacamole-server
#

cd "$BUILD_DIR/guacamole-server-$VERSION"
./configure
make
make install
ldconfig

#
# Clean up after build
#

rm -Rf "$BUILD_DIR/guacamole-server-$VERSION"

#
# Add FreeRDP plugins to proper path
#

FREERDP_DIR=`where_is_freerdp`
FREERDP_PLUGIN_DIR="$FREERDP_DIR/freerdp"

mkdir -p "$FREERDP_PLUGIN_DIR"
ln -s /usr/local/lib/freerdp/*.so "$FREERDP_PLUGIN_DIR"
