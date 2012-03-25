# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2:2.6"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.5 3.*"

inherit distutils subversion

DESCRIPTION="Generate Your Projects"
HOMEPAGE="http://code.google.com/p/gyp/"
SRC_URI=""
ESVN_REPO_URI="http://gyp.googlecode.com/svn/trunk/"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""
