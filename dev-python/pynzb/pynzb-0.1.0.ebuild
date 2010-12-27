# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

SUPPORT_PYTHON_ABIS=1

inherit distutils

DESCRIPTION="Unified API for parsing NZB files"
HOMEPAGE="http://http://pypi.python.org/pypi/pynzb/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""
