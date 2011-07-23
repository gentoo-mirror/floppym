# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit subversion java-pkg-2 java-ant-2

DESCRIPTION="DLNA compliant Upnp Media Server for the PS3"
HOMEPAGE="http://code.google.com/p/ps3mediaserver/"
SRC_URI=""
ESVN_REPO_URI="http://${PN}.googlecode.com/svn/trunk/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

COMMON_DEP="dev-java/commons-configuration
	dev-java/commons-lang:2.1
	dev-java/commons-io:1
	dev-java/jgoodies-forms
	dev-java/jna
	dev-java/slf4j-api"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}"

JAVA_PKG_STRICT=1
JAVA_ANT_REWRITE_CLASSPATH=1
EANT_BUILD_TARGET="PMS"
EANT_GENTOO_CLASSPATH="commons-configuration commons-io-1 commons-lang-2.1
	jgoodies-forms jna slf4j-api"

src_prepare() {
	rm -f lib/* || die
	sed -e /nsisant/d -i build.xml || die
	java-pkg-2_src_prepare
}

src_install() {
	java-pkg_dojar pms.jar
}
