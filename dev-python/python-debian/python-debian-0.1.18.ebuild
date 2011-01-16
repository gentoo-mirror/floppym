# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Python modules to work with Debian-related data formats"
HOMEPAGE="http://packages.debian.org/sid/python-debian"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2 GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

PYTHON_MODNAME="deb822.py debian debian_bundle"

src_prepare() {
	sed -e "s/__CHANGELOG_VERSION__/${PV}/" setup.py.in > setup.py || die
	distutils_src_prepare
}
