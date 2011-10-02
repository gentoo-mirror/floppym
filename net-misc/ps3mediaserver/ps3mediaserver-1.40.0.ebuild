# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils

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

	dodoc CHANGELOG README
	dohtml -r documentation/*

	cat > ${PN} <<-EOF
	#!/bin/sh
	export PMS_HOME="${EPREFIX}/opt/${PN}"
	exec "${EPREFIX}/opt/${PN}/PMS.sh" "\$@"
	EOF
	exeinto /usr/bin
	doexe ${PN}

	jar -xf pms.jar resources/images/icon-{32,256}.png || die
	insinto /usr/share/icons/hicolor/32x32/apps
	newins resources/images/icon-32.png ${PN}.png
	insinto /usr/share/icons/hicolor/256x256/apps
	newins resources/images/icon-256.png ${PN}.png

	cat > ${PN}.desktop <<-EOF
	[Desktop Entry]
	Name=PS3 Media Server
	GenericName=Media Server
	Exec=${PN}
	Icon=${PN}
	Type=Application
	Categories=Network;
	EOF
	domenu ${PN}.desktop
}
