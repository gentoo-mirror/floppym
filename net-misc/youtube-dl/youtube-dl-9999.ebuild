# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit git-2 python

DESCRIPTION="Small command-line program to download videos from YouTube.com and other video sites"
HOMEPAGE="http://rg3.github.com/youtube-dl/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/rg3/youtube-dl.git
	https://github.com/rg3/youtube-dl.git"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE=""

src_install() {
	installing() {
		insinto "$(python_get_sitedir)"
		doins -r youtube_dl
		cp youtube-dl.dev youtube-dl-${PYTHON_ABI} || die
		python_convert_shebangs ${PYTHON_ABI} youtube-dl-${PYTHON_ABI}
		dobin youtube-dl-${PYTHON_ABI}
	}
	python_execute_function installing

	rm youtube-dl || die
	python_generate_wrapper_scripts youtube-dl
	dobin youtube-dl

	dodoc README.md
}

pkg_postinst() {
	python_mod_optimize youtube_dl
}

pkg_postrm() {
	python_mod_cleanup youtube_dl
}
