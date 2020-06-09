# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NTFS driver"
HOMEPAGE="https://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"
MY_P="ntfs-3g_ntfsprogs-${PV%.*}AR.${PV##*.}"
SRC_URI="https://jp-andre.pagesperso-orange.fr/${MY_P}.tgz"

LICENSE="GPL-2+ LGPL-2"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX}"/usr
		--disable-library
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	dosym "${EPREFIX}"/usr/bin/ntfs-3g /sbin/mount.ntfs
	keepdir "/usr/$(get_libdir)/ntfs-3g"
}
