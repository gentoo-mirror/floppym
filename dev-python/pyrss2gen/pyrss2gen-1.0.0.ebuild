# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS=1

inherit distutils

MY_PN="PyRSS2Gen"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Python library for generating RSS 2.0 feeds"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

PYTHON_MODNAME="${MY_PN}.py"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm -f example.py test.py
}
