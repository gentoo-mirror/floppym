# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"

inherit distutils python

DESCRIPTION="RSS feed generator written in Python"
HOMEPAGE="http://www.dalkescientific.com/Python/PyRSS2Gen.html"
SRC_URI="http://www.dalkescientific.com/Python/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

RESTRICT="test"

DEPEND="dev-python/setuptools
	test? ( dev-python/feedparser )"
RDEPEND=""

use examples && DOCS="example.py"
PYTHON_MODNAME="${PN}.py"

src_test() {
	testing() {
		PYTHON_PATH="build-${PYTHON_ABI}/lib" "$(PYTHON)" test.py
	}
	python_execute_function testing
}
