# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools-utils versionator

DESCRIPTION="A Remote Desktop Protocol Client, forked from rdesktop"
HOMEPAGE="http://www.freerdp.com/"
SRC_URI="mirror://sourceforge/${PN}/$(get_version_component_range 1-2)/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa cups debug-channel debug-kbd debug-proto debug-rdp5 debug-serial
	debug-smartcard debug-sound gnutls iconv ipv6 nss polarssl ssl
	static-libs X"

DEPEND="alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	iconv? ( virtual/libiconv )
	ssl? ( >=dev-libs/openssl-0.9.8a )
	!ssl? (
		gnutls? ( >=net-libs/gnutls-2.10.1 )
		!gnutls? (
			nss? ( dev-libs/nss )
			!nss? (
				polarssl? ( >=net-libs/polarssl-0.14.0 )
			)
		)
	)
	X? ( x11-libs/libX11
		x11-libs/libXcursor )"
RDEPEND="${DEPEND}
	X? ( x11-apps/setxkbmap )"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local crypto=(
		$(use ssl && echo openssl)
		$(usev gnutls)
		$(usev nss)
		$(usev polarssl)
		simple
	)
	[[ ${#crypto[@]} > 2 ]] && \
		ewarn "Multiple crypto backends selected, using ${crypto[0]}"

	# chipcard and directfb are configurable according to ./configure
	# but they are currently not usable...
	local myeconfargs=(
		$(use_enable iconv)
		$(use_enable ipv6)
		--enable-largefile
		--disable-smartcard
		$(use_with alsa sound alsa)
		--with-crypto=${crypto[0]}
		$(use_with cups printer cups)
		$(use_with debug-channel)
		$(use_with debug-kbd)
		$(use_with debug-proto debug)
		$(use_with debug-rdp5)
		$(use_with debug-serial)
		$(use_with debug-smartcard)
		$(use_with debug-sound)
		#$(use_with directfb dfb)
		$(use_with X x)
	)

	autotools-utils_src_configure
}
