# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

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
	python_convert_shebangs 2 youtube-dl
	dobin youtube-dl
}
