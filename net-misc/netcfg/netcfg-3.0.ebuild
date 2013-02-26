# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Profile based network connection tool from Arch Linux"
HOMEPAGE="https://www.archlinux.org/netcfg/"
SRC_URI="ftp://ftp.archlinux.org/other/${PN}/${P}.tar.xz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=">=app-shells/bash-4.0
	sys-apps/iproute2"

src_compile() {
	:
}

src_install() {
	emake DESTDIR="${D%/}" SHELL=bash install
	rm -r "${D}"etc/rc.d || die
	mv "${D}"usr/share/doc/{${PN},${PF}} || die
	dodoc AUTHORS NEWS README
}
