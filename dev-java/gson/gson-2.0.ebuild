# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java library to convert JSON to Java objects and vice-versa"
HOMEPAGE="http://code.google.com/p/google-gson/"
SRC_URI="http://google-gson.googlecode.com/files/google-${P}-release.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

src_unpack() {
	unpack ${A} "./google-${P}/${P}-sources.jar"
}
