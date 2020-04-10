# Webkit2GTK-GLES2
A script and packages for a GLES2-enabled Webkit2GTK for Debian.

## Description
The debian binary packages for Webkit2GTK are not compiled with ENABLE_GLES2. This means it isn't possible to use, for example, WebGL in Webkit based browsers on ARM. As it turns out, cross-compiling Webkit2GTK is a though job, because of the dependency on gobject-introspection, which doesn't cross-compile easily.

This project provides a script and the packages for an armhf system so you can use this without too much hassle. I also provide a debian repository which you can use in your system to ensure you always have the latest packages available.

### How does it work?
We only recompile the packages we are actually interested in: libjavascriptcoregtk and libwebkit2gtk. These packages also don't need INTROSPECTION to be enabled, so we can cross-compile these. These packages provide a drop-in replacement for use in an existing Debian system.

In order for this to work, we modify the source to only include the packages we are interested in. After that, we just use a standard sbuild build system to build the packages.

## Repository
If you just want to use these packages without building them, you can use my repository at `deb.pascalroeleven.nl` by adding this line to your sources.list:
```sh
deb http://deb.pascalroeleven.nl/webkit2gtk-gles2 buster main
```
You should also add my PGP (which you can get from my website via https) to APT's sources keyring:
```sh
wget https://pascalroeleven.nl/deb-pascalroeleven.gpg
sudo apt-key add deb-pascalroeleven.gpg
```
If you already have libjavascriptcoregtk and libwebkit2gtk installed, performing an `apt upgrade` will upgrade the packages to the gles2-enabled version (unless the packages in my repository are older ofcourse). 

The packages there are built for the latest debian stable only, including patches applied by security and stable/updates. I only build packages for `armhf` as that's probably the only architecture where this is particularly useful for. My packages can be recognized by `glesX` appended to the version number, where `X` is the number of the revision.

## Requirements
* A working sbuild build system
* A pretty beefy PC (at least 16GB ram)
* Git

## Usage
1. Setup a sbuild build system as described on https://wiki.debian.org/sbuild

2. Add additional repositories to your sbuild. I always want the latest updates and security updates for Debian, so I add those repositories to etc/apt/sources.list in sbuild.

3. Update the sbuild build system:

`$SBUILD`: Name of your sbuild: `buster-amd64-sbuild`
```sh
sudo sbuild-update -udcar $SBUILD
```

4. Download the webkit submodule:

```sh
git submodule update --init --depth=1
```

OR: Alternatively, you can also manually clone webkit from debian:

`$TAG`: Build tag to download: `debian/2.26.4-1_deb10u2`
```sh
git clone --depth=1 https://salsa.debian.org/webkit-team/webkit.git -b $TAG
```

5. Patch the source files with `patchsource` from this repository:

```sh
./patchsource
```

6. Change into the source directory:

```sh
cd webkit
```

7. (Optionally) change the version number so you can distinguish your packages from the one in the official repository:

`$VERSION`: New version number: `2.26.4-1~deb10u2gles1`
```sh
debchange --newversion $VERSION
```

8. Build the packages with sbuild:

`$RELEASE`: Release your sbuild uses: `buster`
`--add-depends=libfile-copy-recursive-perl:all`: Because libfile-copy-recursive-perl isn't Multi-Arch friendly, we will get a dependency error otherwise.
```sh
sbuild -b -d $RELEASE --add-depends=libfile-copy-recursive-perl:all --host=armhf
```

