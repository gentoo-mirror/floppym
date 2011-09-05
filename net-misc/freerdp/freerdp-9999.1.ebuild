# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

#EGIT_REPO_URI="git://github.com/FreeRDP/FreeRDP-1.0.git"
EGIT_REPO_URI="/home/floppym/src/FreeRDP-1.0"
EGIT_BRANCH="gentoo-patches"

DESCRIPTION="A Remote Desktop Protocol Client, forked from rdesktop"
HOMEPAGE="http://www.freerdp.com/"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+alsa +cups directfb pulseaudio test +X +xcursor +xext +xinerama +xkbfile"

RDEPEND="
	dev-libs/openssl
	sys-libs/zlib
	alsa? ( media-libs/alsa-lib )
	cups? ( net-print/cups )
	directfb? ( dev-libs/DirectFB )
	pulseaudio? ( media-sound/pulseaudio )
	X? (
		x11-libs/libX11
		xcursor? ( x11-libs/libXcursor )
		xext? ( x11-libs/libXext )
		xinerama? ( x11-libs/libXinerama )
	)
	xkbfile? ( x11-libs/libxkbfile )
"
DEPEND="${RDEPEND}
	app-text/xmlto
	test? ( dev-util/cunit )
"

src_configure() {
	# TODO: Add option to disable X entirely
	local mycmakeargs=(
		-DWITH_MANPAGES=ON
		$(cmake-utils_use_with alsa)
		$(cmake-utils_use_with cups)
		$(cmake-utils_use_with directfb)
		$(cmake-utils_use_with pulseaudio)
		$(cmake-utils_use_with test CUNIT)
		$(cmake-utils_use_with X X11)
		$(cmake-utils_use_with xcursor)
		$(cmake-utils_use_with xext)
		$(cmake-utils_use_with xinerama)
		$(cmake-utils_use_with xkbfile)
	)
	cmake-utils_src_configure
}
