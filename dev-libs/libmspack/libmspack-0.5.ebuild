# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="A library for Microsoft compression formats"
HOMEPAGE="http://www.cabextract.org.uk/libmspack/"
SRC_URI="http://www.cabextract.org.uk/libmspack/libmspack-0.5alpha.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/libmspack-0.5alpha

src_configure() {
	econf --enable-shared --disable-static
}

src_install() {
	default
	prune_libtool_files
}
