# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils subversion java-pkg-2 java-ant-2

DESCRIPTION="DLNA compliant UPNP server for streaming media to Playstation 3"
HOMEPAGE="http://code.google.com/p/ps3mediaserver"
SRC_URI=""
ESVN_REPO_URI="http://ps3mediaserver.googlecode.com/svn/trunk/ps3mediaserver"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="+transcode tsmuxer"

DEPEND="
	>=virtual/jdk-1.6
"
RDEPEND="
	>=virtual/jre-1.6
	media-libs/libmediainfo
	media-libs/libzen
	tsmuxer? ( media-video/tsmuxer )
	transcode? ( media-video/mplayer[encode] )
"

# Add a java package to [R]DEPEND and EANT_GENTOO_CLASSPATH
# Also remove bundled jar files
# $1: Pacakge name
# $2: Optional slot
# $3: Optional use-dep
java_dep() {
	DEPEND+=" dev-java/$1:${2:-0}${3:+[$3]}"
	RDEPEND+=" dev-java/$1:${2:-0}${3:+[$3]}"
	EANT_GENTOO_CLASSPATH+=" $1${2:+-$2}"
	REMOVE_JARS+=" $1-*.jar"
}

java_dep bsh
java_dep commons-codec
java_dep commons-configuration
java_dep commons-httpclient 3
java_dep commons-io 1
java_dep commons-lang 2.1
java_dep commons-logging
java_dep gson
java_dep jdom 1.0
java_dep jgoodies-forms
java_dep jgoodies-looks 2.0
java_dep jna
java_dep rome
java_dep slf4j-api

REMOVE_JARS+=" commons-collections*.jar jgoodies-common*.jar"

EANT_BUILD_TARGET="PMS"
JAVA_ANT_REWRITE_CLASSPATH=1

src_unpack() {
	(
		umask 002
		subversion_fetch
	) || die
}

java_prepare() {
	rm -rf osx win32 || die

	if [[ -n ${REMOVE_JARS} ]]; then
		pushd lib > /dev/null
		rm -v ${REMOVE_JARS} || die
		popd > /dev/null
	fi
}

src_install() {
	java-pkg_dojar pms.jar
	java-pkg_dolauncher ${PN} --main net.pms.PMS --pwd /usr/share/${PN}

	insinto /usr/share/${PN}
	doins -r *.conf documentation logback*.xml plugins renderers
	dodoc CHANGELOG README
	use tsmuxer && dosym /opt/tsmuxer/bin/tsMuxeR /usr/share/${PN}/linux/tsMuxeR

	insinto /usr/share/icons/hicolor/32x32/apps
	newins resources/images/icon-32.png ${PN}.png
	insinto /usr/share/icons/hicolor/256x256/apps
	newins resources/images/icon-256.png ${PN}.png

	cat > ${PN}.desktop <<-EOF
	[Desktop Entry]
	Name=PS3 Media Server
	GenericName=Media Server
	Exec=${PN}
	Icon=${PN}
	Type=Application
	Categories=Network;
	EOF
	domenu ${PN}.desktop

	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
}
