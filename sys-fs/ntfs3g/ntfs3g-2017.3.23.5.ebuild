# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION=""
HOMEPAGE=""
MY_P="ntfs-3g_ntfsprogs-${PV%.*}AR.${PV##*.}"
SRC_URI="https://jp-andre.pagesperso-orange.fr/${MY_P}.tgz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${MY_P}"

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX}"/usr
		--disable-ldconfig
	)
	econf "${myconf[@]}"
}
