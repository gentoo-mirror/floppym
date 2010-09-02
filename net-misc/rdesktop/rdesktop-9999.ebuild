# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit autotools eutils subversion

DESCRIPTION="A Remote Desktop Protocol Client"
HOMEPAGE="http://rdesktop.sourceforge.net/"
ESVN_REPO_URI="https://rdesktop.svn.sourceforge.net/svnroot/rdesktop/rdesktop/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa ao ipv6 oss pcsc-lite"

RDEPEND="
	dev-libs/openssl
	alsa? ( media-libs/alsa-lib )
	ao? ( media-libs/libao )
	media-libs/libsamplerate
	pcsc-lite? ( sys-apps/pcsc-lite )
	x11-libs/libXrandr
	x11-libs/libX11"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/secure.c-32bpp-fallback.patch || die

	sed -e '/$(STRIP)/d' \
		#-e 's/^LDFLAGS\(.*\)@LDFLAGS@ \(.*\)/LDLIBS \1\2 -lX11/' \
		#-e '/ -o rdesktop /d' \
		#-e '/^\.SUFFIXES:/d' \
		#-e '/^\.c\.o:$/d' \
		#-e '/$(CC) $(CFLAGS) -o $@ -c $</d' \
		-i Makefile.in || die

	eautoreconf || die
}

src_configure() {
	local sound=$(usev ao || usev alsa || usev oss || echo no)

	econf \
		$(use_with ipv6) \
		--with-openssl=/usr \
		--with-sound=${sound} \
		$(use_enable pcsc-lite smartcard) \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
