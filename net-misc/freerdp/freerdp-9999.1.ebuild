# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit cmake-utils git-2

EGIT_REPO_URI="git://github.com/FreeRDP/FreeRDP-1.0.git"

DESCRIPTION="A Remote Desktop Protocol Client, forked from rdesktop"
HOMEPAGE="http://www.freerdp.com/"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="alsa cups pulseaudio X"

DEPEND="dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	cups? ( net-print/cups )
	sys-libs/zlib
	X? (
		x11-libs/libX11
		x11-libs/libxkbfile
		x11-libs/libXext
		x11-libs/libXcursor
		x11-libs/libXinerama
	)"
RDEPEND="${DEPEND}"

freerdp_use_with() {
	local opt=${2:-$(echo "${1}" | tr '[:lower:]' '[:upper:]')}

	if use "${1}"; then
		echo "-DWITH_${opt}=ON"
		echo "-DWITHOUT_${opt}=OFF"
	else
		echo "-DWITH_${opt}=OFF"
		echo "-DWITHOUT_${opt}=ON"
	fi
}

src_configure() {
	# TODO: Add option to disable X entirely
	local mycmakeargs=(
		$(freerdp_use_with alsa)
		$(freerdp_use_with cups)
		$(freerdp_use_with pulseaudio)
	)
	cmake-utils_src_configure
}
