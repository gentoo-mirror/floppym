# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

DESCRIPTION="A program for losslessly re-packing MP3 files"
HOMEPAGE="http://omion.dyndns.org/mp3packer/mp3packer.html"
SRC_URI="http://omion.dyndns.org/mp3packer/${P}_src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	app-arch/unzip
	dev-lang/ocaml"

S="${WORKDIR}"

src_compile() {
	emake EXE_EXT="" OBJ_EXT=".o" || die
}

src_install() {
	dobin mp3packer mp3reader || die
	dodoc gpl.txt || die
	dohtml mp3packer.html || die
}
