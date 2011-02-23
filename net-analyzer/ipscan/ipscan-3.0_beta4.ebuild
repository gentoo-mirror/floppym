# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit java-pkg-2

DESCRIPTION="Angry IP - The fast and friendly network scanner"
HOMEPAGE="http://www.angryip.org"

MY_PV=${PV/_/-}
SRC_BASE="mirror://sourceforge/${PN}/${PN}${PV:0:1}-binary/${MY_PV}"
SRC_URI="amd64? ( ${SRC_BASE}/${PN}-linux64-${MY_PV}.jar )
	x86? ( ${SRC_BASE}/${PN}-linux-${MY_PV}.jar )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.6.0"

INSTALL_DIR=/opt/AngryIP

S=${WORKDIR}

src_unpack() {
	:
}

src_install() {
	local jarname
	use amd64 && jarname="${PN}-linux64-${MY_PV}.jar"
	use x86 && jarname="${PN}-linux-${MY_PV}.jar"
	java-pkg_jarinto "${INSTALL_DIR}"
	java-pkg_newjar "${DISTDIR}/${jarname}"
	java-pkg_dolauncher
}
