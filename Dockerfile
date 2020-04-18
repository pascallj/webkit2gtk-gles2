# This file is only used to run automated builds using Github runners.

FROM debian:buster-slim

RUN set -ex; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		sbuild schroot debootstrap devscripts debhelper

RUN sbuild-createchroot buster /srv/chroot/buster-sbuild

RUN echo 'deb http://deb.debian.org/debian-security buster/updates main\n\
deb-src http://deb.debian.org/debian-security buster/updates main\n\
\n\
deb http://deb.debian.org/debian buster-updates main\n\
deb-src http://deb.debian.org/debian buster-updates main\n\
' >> /srv/chroot/buster-sbuild/etc/apt/sources.list

ENTRYPOINT ["./entrypoint.sh"]
