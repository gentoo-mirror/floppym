# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-vcs/hgsubversion/hgsubversion-1.2.1.ebuild,v 1.3 2011/05/23 19:52:45 hwoarang Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils mercurial

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories."
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion/wiki/Home http://pypi.python.org/pypi/hgsubversion"
SRC_URI=""
EHG_REPO_URI="https://bitbucket.org/durin42/hgsubversion"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND=">=dev-vcs/mercurial-1.4
	|| (
		dev-python/subvertpy
		>=dev-vcs/subversion-1.5[python]
	)"
DEPEND="dev-python/setuptools
	test? ( dev-python/nose )"

DOCS="README"

src_prepare() {
	distutils_src_prepare
}

src_test() {
	cd tests

	testing() {
		PYTHONPATH="../build-${PYTHON_ABI}/lib" "$(PYTHON)" run.py
	}
	python_execute_function testing
}
