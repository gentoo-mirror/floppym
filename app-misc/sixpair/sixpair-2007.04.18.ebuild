# Copyright 2011-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Utility to initiate bluetooth pairing with a PS3 controller"
HOMEPAGE="http://www.pabr.org/sixlinux/sixlinux.en.html"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/libusb:0"
RDEPEND="${DEPEND}
	net-wireless/bluez"

S=${WORKDIR}

src_compile() {
	local pkgconfig="$(tc-getPKG_CONFIG)"
	local libusb_cflags="$(${pkgconfig} --cflags libusb)"
	local libusb_libs="$(${pkgconfig} --libs libusb)"
	local compile=(
		$(tc-getCC)
		${CFLAGS} ${CPPFLAGS}
		${libusb_cflags}
		-o sixpair
		${LDFLAGS}
		"${FILESDIR}"/sixpair.c
		${libusb_libs}
	)
	echo "${compile[@]}" >&2
	"${compile[@]}" || die
}

src_install() {
	dobin sixpair
}
