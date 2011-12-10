# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit cmake-utils flag-o-matic

DESCRIPTION="RStudio™ is a new integrated development environment (IDE) for R. RStudio combines an intuitive user interface with powerful coding tools to help you get the most out of R."
HOMEPAGE="http://rstudio.org/"

GIN_VER=1.5
GWT_SDK_VER=2.3.0

SRC_URI="https://github.com/rstudio/rstudio/tarball/v${PV}/${P}.tar.gz
		 https://s3.amazonaws.com/rstudio-buildtools/gwt-${GWT_SDK_VER}.zip
		 https://s3.amazonaws.com/rstudio-buildtools/gin-${GIN_VER}.zip"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~x86 ~amd64"

#RESTRICT="strip"

DEPEND="dev-util/cmake
		dev-java/ant"

RDEPEND="${DEPEND}
		dev-libs/openssl
		sys-libs/pam
		app-arch/bzip2
		x11-libs/pango
		dev-libs/boost
		virtual/jdk"

src_unpack() {
	unpack ${P}.tar.gz
	mv ${PN}* ${P}
	cd ${P}
	GWT_DIR=src/gwt
	LIB_DIR=$GWT_DIR/lib
	mkdir -p "${LIB_DIR}/gin/${GIN_VER}"
	unzip -qd "${LIB_DIR}/gin/${GIN_VER}" "${DISTDIR}/gin-${GIN_VER}.zip"
	mkdir -p "${LIB_DIR}/gwt"
	unzip -qd "${LIB_DIR}" "${DISTDIR}/gwt-${GWT_SDK_VER}.zip"
	mv "${LIB_DIR}/gwt-${GWT_SDK_VER}" "${LIB_DIR}/gwt/${GWT_SDK_VER}"
}

src_configure() {
	mkdir build
	cd build
	cmake -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release ..
}

src_compile() {
	cd build
	emake
}

src_install() {
	cd build
	emake install
}
