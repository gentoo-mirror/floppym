# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="ASA Carriage control conversion for ouput by Fortran programs"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/"
SRC_URI="http://www.ibiblio.org/pub/Linux/devel/lang/fortran/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -e '/^CFLAGS/d' -e '/$(CC)/d' -i Makefile || die
}

src_install() {
	dobin asa
	doman asa.1
}
