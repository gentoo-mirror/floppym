# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

MY_P="${PN}-${PV//./_}"
DESCRIPTION="JGoodies Common Library"
HOMEPAGE="http://www.jgoodies.com/"
SRC_URI="http://www.jgoodies.com/download/libraries/common/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

src_install() {
	java-pkg_dojar "build/${PN}.jar"
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc src/core
}
