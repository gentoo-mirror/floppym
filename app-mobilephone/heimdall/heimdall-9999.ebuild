# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools eutils qt4-r2 git-2

DESCRIPTION="Tool suite used to flash firmware onto Samsung Galaxy S devices"
HOMEPAGE="http://www.glassechidna.com.au/products/heimdall/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/Benjamin-Dobell/Heimdall.git
	https://github.com/Benjamin-Dobell/Heimdall.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="qt4"

RDEPEND="virtual/libusb:1
	qt4? ( x11-libs/qt-core x11-libs/qt-gui )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	rm -r libusb-1.0 || die

	cd "${S}/heimdall" || die
	edos2unix configure.ac Makefile.am || die
	sed -i -e /sudo/d Makefile.am || die
	eautoreconf
}

src_configure() {
	cd "${S}/libpit" || die
	econf

	cd "${S}/heimdall" || die
	econf

	if use qt4; then
		cd "${S}/heimdall-frontend" || die
		eqmake4 heimdall-frontend.pro OUTPUTDIR=/usr/bin || die
	fi
}

src_compile() {
	cd "${S}/libpit" || die
	emake

	cd "${S}/heimdall" || die
	emake

	if use qt4; then
		cd "${S}/heimdall-frontend" || die
		emake
	fi
}

src_install() {
	cd "${S}/heimdall" || die
	emake DESTDIR="${D}" install

	if use qt4; then
		cd "${S}/heimdall-frontend" || die
		emake INSTALL_ROOT="${D}" install
	fi
}
