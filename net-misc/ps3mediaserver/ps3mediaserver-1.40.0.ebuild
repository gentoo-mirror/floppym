# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="DLNA compliant Upnp Media Server for the PS3"
HOMEPAGE="http://ps3mediaserver.org"
SRC_URI="http://${PN}.googlecode.com/files/pms-generic-linux-unix-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6.0
	media-libs/libmediainfo
	media-libs/libzen"

QA_PREBUILT="*"
S="${WORKDIR}/pms-linux-${PV}"

src_install() {
	insinto /opt/${PN}
	doins logback*.xml pms.jar WEB.conf
	doins -r plugins renderers

	exeinto /opt/${PN}
	doexe PMS.sh

	exeinto /opt/${PN}/linux
	doexe linux/tsMuxeR

	cat > ${PN} <<-EOF
	#!/bin/sh
	export PMS_HOME="${EPREFIX}/opt/${PN}"
	exec "${EPREFIX}/opt/${PN}/PMS.sh" "\$@"
	EOF
	exeinto /usr/bin
	doexe ${PN}

	dodoc CHANGELOG README
	dohtml -r documentation/*
}
