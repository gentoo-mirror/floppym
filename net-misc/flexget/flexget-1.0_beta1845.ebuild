# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

if [[ ${PV} == 9999 ]]; then
	inherit subversion
	ESVN_REPO_URI="http://svn.flexget.com/trunk"
	KEYWORDS=""
else
	MY_P="FlexGet-${PV/_beta/r}"
	SRC_URI="http://download.flexget.com/unstable/${MY_P}.tar.gz"
	KEYWORDS="~amd64"
	S=${WORKDIR}/${MY_P}
fi

DESCRIPTION="A multipurpose automation tool for content like torrents, nzbs, podcasts, comics, etc."
HOMEPAGE="http://flexget.com/"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="dev-python/setuptools
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

src_prepare() {
	# Prevent setup from grabbing nose from pypi
	sed -e /setup_requires/d -i pavement.py || die

	if [[ ${PV} == 9999 ]]; then
		# Generate setup.py
		paver generate_setup || die
	else
		# Remove bundled paver
		rm -f paver-minilib.zip
	fi

	distutils_src_prepare
}
