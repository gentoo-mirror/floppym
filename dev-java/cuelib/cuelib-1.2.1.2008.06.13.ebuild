# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 versionator

DESCRIPTION="Java library for manipulating cue sheets"
HOMEPAGE="http://code.google.com/p/cuelib/"
MY_P=$(version_format_string '${PN}-src-$1.$2.$3-$4-$5-$6')
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

EANT_BUILD_TARGET="makeJar"
EANT_DOC_TARGET="makeDoc"

S=${WORKDIR}

src_unpack() {
	unpack ${A}

	[[ -f config/doc/stylesheet.css ]] && die "stylesheet.css in source file"
	mkdir -p config/doc || die
	cp "${FILESDIR}/stylesheet.css" config/doc || die
}

src_install() {
	java-pkg_newjar dist/${PN}-*.jar ${PN}.jar
	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src
}
