# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils flag-o-matic git-2 toolchain-funcs

DESCRIPTION="Simple mapping tool for minecraft"
HOMEPAGE="http://seancode.com/minutor/"
EGIT_REPO_URI="git://github.com/mrkite/minutor.git"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="x11-libs/gtk+:2"
RDEPEND="${DEPEND}"

src_compile() {
	tc-export PKG_CONFIG
	append-cflags -std=c99
	emake AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		GTK_INC="$(${PKG_CONFIG} --cflags gtk+-2.0)" \
		GTK_LIB="$(${PKG_CONFIG} --libs gtk+-2.0)"
}

src_install() {
	dobin minutor
	domenu minutor.desktop
	doicon -s 48 minutor.png
	doicon minutor.xpm
}
