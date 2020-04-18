#!/bin/bash

# This file is only used to run automated builds using Github runners.

set -ex

./patchsource
cd webkit
tar --exclude=debian -czf ../webkit2gtk_"$(dpkg-parsechangelog --show-field Version | sed s/-.*//)".orig.tar.gz .
DEBFULLNAME="Pascal Roeleven" DEBEMAIL="dev@pascalroeleven.nl" debchange -lgles "Enable GLES2"
sbuild -b -d buster --add-depends=libfile-copy-recursive-perl:all --host=armhf --apt-update --apt-distupgrade
