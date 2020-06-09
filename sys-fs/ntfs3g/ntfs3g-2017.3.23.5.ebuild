# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NTFS driver"
HOMEPAGE="https://jp-andre.pagesperso-orange.fr/advanced-ntfs-3g.html"

MY_P="ntfs-3g_ntfsprogs-${PV%.*}AR.${PV##*.}"
S="${WORKDIR}/${MY_P}"
SRC_URI="https://jp-andre.pagesperso-orange.fr/${MY_P}.tgz"

LICENSE="GPL-2+ LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static-libs"

DEPEND="sys-apps/util-linux:0="
RDEPEND="${DEPEND}"

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX}"/usr
		--disable-ldconfig
		$(use_enable static-libs static)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -type f -delete || die
}
