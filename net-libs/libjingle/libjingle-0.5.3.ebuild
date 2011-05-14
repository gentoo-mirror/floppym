# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit eutils scons-utils

DESCRIPTION="Google Talk Voice and P2P Interoperability Library"
HOMEPAGE="http://code.google.com/p/libjingle/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz
	http://swtoolkit.googlecode.com/files/swtoolkit.0.9.1.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-libs/expat
	>=net-libs/libsrtp-1.4.4_p20110513"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${S}/talk"

src_prepare() {
	sed -e 's:^#include "srtp\.h":#include <srtp/srtp.h>:' \
		-i session/phone/srtpfilter.cc || die

	sed -e 's:^#include "lib/expat.h":#include <expat.h>:' \
		-i xmllite/xml{builder,parser}.{cc,h} xmpp/xmppstanzaparser.cc || die

	epatch "${FILESDIR}/${PN}-shared.patch"
}

src_compile() {
	escons -f main.scons \
		--site-dir="${WORKDIR}/swtoolkit/site_scons" \
		--verbose \
		--host-platform=LINUX \
		libjingle
}
