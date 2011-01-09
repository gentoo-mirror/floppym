# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils python

DESCRIPTION="A Python library for generating RSS 2.0 feeds"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools
	test? ( dev-python/feedparser )"
RDEPEND=""

DOCS="example.py"
PYTHON_MODNAME="${PN}.py"

src_prepare() {
	# Remove extra modules from py_modules
	sed -e "s/py_modules = .*/py_modules = ['${PN}']/" -i setup.py || die

	distutils_src_prepare
}

src_test() {
	testing() {
		"$(PYTHON)" test.py
	}
	python_execute_function testing
}
