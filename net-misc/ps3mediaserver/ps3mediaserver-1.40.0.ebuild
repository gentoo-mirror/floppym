# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils java-pkg-2

DESCRIPTION="DLNA compliant Upnp Media Server for the PS3"
HOMEPAGE="http://ps3mediaserver.org"
SRC_URI="http://${PN}.googlecode.com/files/pms-generic-linux-unix-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=">=virtual/jre-1.5
	media-libs/libmediainfo
	media-libs/libzen
	media-video/tsmuxer"

QA_PREBUILT="*"
S="${WORKDIR}/pms-linux-${PV}"

src_install() {
	java-pkg_dojar pms.jar
	java-pkg_dolauncher ps3mediaserver --main net.pms.PMS \
		--pwd /usr/share/${PN}

	insinto /usr/share/${PN}
	doins logback*.xml WEB.conf
	doins -r plugins renderers

	dosym /opt/tsmuxer/bin/tsMuxeR /usr/share/${PN}/linux/tsMuxeR

	dodoc CHANGELOG README
	dohtml -r documentation/*

	unzip -j pms.jar resources/images/icon-{32,256}.png || die
	insinto /usr/share/icons/hicolor/32x32/apps
	newins icon-32.png ${PN}.png
	insinto /usr/share/icons/hicolor/256x256/apps
	newins icon-256.png ${PN}.png

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
