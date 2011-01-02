# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils git toolchain-funcs

DESCRIPTION="Tools for hacking the Sony PlayStation 3 console"
HOMEPAGE="http://fail0verflow.com/"
EGIT_REPO_URI="git://git.fail0verflow.com/ps3tools.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${PN}-respect-ldflags.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install() {
	dobin readself pupunpack unself unpkg sceverify makeself makepkg \
		norunpack puppack || die
}
