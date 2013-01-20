# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils libtool multilib

DESCRIPTION="libudev compatibility library for old binaries"
HOMEPAGE="http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev/"
MY_P="udev-${PV}"
SRC_URI="mirror://kernel/linux/utils/kernel/hotplug/${MY_P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# Unconditional pkg-config checks
DEPEND=">=sys-apps/kmod-5
	>=sys-apps/util-linux-2.20"

# Other providers of libudev.so.0
RDEPEND="!<sys-fs/eudev-1_beta
	!<sys-fs/udev-183"

S=${WORKDIR}/${MY_P}

src_prepare() {
	elibtoolize
}

src_configure() {
	local myeconfargs=(
		--with-rootprefix=
		--with-rootlibdir="/$(get_libdir)"
		--libexecdir=/lib
		--disable-static
		--disable-manpages
		--disable-gudev
		--disable-introspection
		--disable-keymap
		--disable-mtd_probe
		--without-selinux
		--with-pci-ids-path=/usr/share/misc/pci.ids
		--with-usb-ids-path=/usr/share/misc/usb.ids
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	emake libudev.la
}

src_install() {
	emake DESTDIR="${D}" install-libLTLIBRARIES
	rm "${ED}usr/$(get_libdir)"/libudev.{la,so} || die
}
