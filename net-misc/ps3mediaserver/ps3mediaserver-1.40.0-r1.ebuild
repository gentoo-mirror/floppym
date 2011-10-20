# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit java-pkg-2 java-ant-2

DESCRIPTION="DLNA compliant Upnp Media Server for the PS3"
HOMEPAGE="http://www.ps3mediaserver.org/"
SRC_URI="mirror://gentoo/${P}.tar.xz
	http://dev.gentoo.org/~floppym/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

JDEPEND="
	bsh
	commons-codec
	commons-collections
	commons-configuration
	commons-httpclient:3
	commons-io:1
	commons-lang:2.1
	commons-logging
	cuelib
	google-gson
	jdom:1.0
	jgoodies-forms
	jgoodies-looks:2.0
	jna
	netty
	rome
	slf4j-api
"
#JDEPEND+="
#	h2
#	jaudiotagger
#	java-unrar
#	goodies-common
#	logback-classic
#	logback-core
#	mediautil
#	sanselan
#"

for x in ${JDEPEND}; do
	DEPEND+=" dev-java/${x}"
	RDEPEND+=" dev-java/${x}"
	if [[ ${EANT_GENTOO_CLASSPATH} ]]; then
		EANT_GENTOO_CLASSPATH+=,${x}
	else
		EANT_GENTOO_CLASSPATH=${x}
	fi
done

src_prepare() {
	cp "${FILESDIR}/build.xml" build.xml || die
	rm -rf osx win32 || die
	java-pkg-2_src_prepare
}
