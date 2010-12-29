# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

SUPPORT_PYTHON_ABIS=1

inherit distutils python

MY_PN=PyRSS2Gen
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Python library for generating RSS 2.0 feeds"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/feedparser )"
RDEPEND=""

S=${WORKDIR}/${MY_P}
DOCS="example.py"
PYTHON_MODNAME=${MY_PN}.py

src_prepare() {
	# Remove extra modules from py_modules
	sed -e "s/py_modules = .*/py_modules = ['${MY_PN}']/" -i setup.py || die
	distutils_src_prepare
}

src_test() {
	testing() {
		"$(PYTHON)" test.py
	}
	python_execute_function testing
}
