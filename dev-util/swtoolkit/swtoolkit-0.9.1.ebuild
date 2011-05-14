# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2:2.4"

inherit multilib python

DESCRIPTION="A set of extensions to the open-source SCons build tool"
HOMEPAGE="http://code.google.com/p/swtoolkit/"
SRC_URI="http://${PN}.googlecode.com/files/${PN}.${PV}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-util/scons"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}"

pkg_setup() {
	python_set_active_version 2
}

src_install() {
	insinto /usr/share/${PN}
	doins -r site_scons wrapper.py || die
	exeinto /usr/share/${PN}
	doexe hammer.sh || die
}

pkg_postinst() {
	python_mod_optimize /usr/share/${PN}/site_scons
}

pkg_postrm() {
	python_mod_cleanup /usr/share/${PN}/site_scons
}
