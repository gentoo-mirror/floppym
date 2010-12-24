# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils subversion

DESCRIPTION="A multipurpose automation tool for content like torrents, nzbs, podcasts, comics, etc."
HOMEPAGE="http://flexget.com/"

ESVN_REPO_URI="http://svn.flexget.com/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

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

DEPEND="${RDPEEND}
	dev-python/paver
	>=dev-python/nose-0.11"

src_prepare() {
	paver generate_setup
}
