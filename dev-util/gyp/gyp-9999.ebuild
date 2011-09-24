# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.4 3.*"

inherit distutils subversion

DESCRIPTION="Generate Your Projects"
HOMEPAGE="http://code.google.com/p/gyp/"
SRC_URI=""
ESVN_REPO_URI="http://gyp.googlecode.com/svn/trunk"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	epatch "${FILESDIR}/gyptest-pythonpath.patch"
	distutils_src_prepare
}

src_test() {
	testing() {
		PYTHONPATH="test/lib:build-${PYTHON_ABI}/lib" "$(PYTHON)" gyptest.py -a -f make
	}
	python_execute_function testing
}
