# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{6..8}} )

inherit distutils-r1

DESCRIPTION="Python library to simplify working with jsonlines and ndjson data"
HOMEPAGE="https://jsonlines.readthedocs.io/ https://github.com/wbolster/jsonlines"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
