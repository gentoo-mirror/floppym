# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

MY_P="FlexGet-${PV/_beta/r}"

DESCRIPTION="A multipurpose automation tool for content like torrents, nzbs, podcasts, comics, etc."
HOMEPAGE="http://flexget.com/"
SRC_URI="http://download.flexget.com/unstable/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/feedparser
	>dev-python/sqlalchemy-0.5
	dev-python/pyyaml
	dev-python/beautifulsoup
	>=dev-python/html5lib-0.11
	dev-python/pygooglechart
	dev-python/pyrss2gen
	dev-python/pynzb
	dev-python/progressbar
	dev-python/flask
	dev-python/cherrypy"

DEPEND="${RDEPEND}
	dev-python/paver
	test? ( >=dev-python/nose-0.11 )"

S=${WORKDIR}/${MY_P}

src_prepare() {
	rm -f paver-minilib.zip
	sed -e /setup_requires/d -i pavement.py || die
	distutils_src_prepare
}
