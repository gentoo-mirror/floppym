# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2

DESCRIPTION="Java library to convert JSON to Java objects and vice-versa"
HOMEPAGE="http://code.google.com/p/google-gson/"
SRC_URI="http://${PN}.googlecode.com/files/${P}-release.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND="app-arch/unzip"

src_install() {
	java-pkg_newjar gson-${PV}.jar gson.jar
}
