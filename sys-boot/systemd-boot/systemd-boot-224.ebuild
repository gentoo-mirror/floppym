# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

DESCRIPTION="EFI boot loader from systemd (formerly gummiboot)"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/systemd/"
SRC_URI="https://github.com/systemd/systemd/archive/v${PV}.tar.gz -> systemd-${PV}.tar.gz"

LICENSE="GPL-2 LGPL-2.1 MIT public-domain"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

COMMON_DEPEND="
	>=sys-apps/util-linux-2.26:0=
	sys-libs/libcap:0=
"
DEPEND="${COMMON_DEPEND}
	>=dev-util/intltool-0.50
	>=sys-boot/gnu-efi-3.0.2
"
RDEPEND="${COMMON_DEPEND}
	!sys-apps/systemd
"

S="${WORKDIR}/systemd-${PV}"

src_prepare() {
	epatch_user
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--enable-blkid
		--enable-efi
		--enable-gnuefi
		--disable-acl
		--disable-elfutils
		--disable-gcrypt
		--disable-libidn
		--disable-seccomp
		--disable-xz
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	case "${CHOST}" in
		x86_64*) EFI_MT=x64 ;;
		i?86*) EFI_MT=ia32 ;;
		aarch64*) EFI_MT=aa64 ;;
		*) die "Unsupported arch" ;;
	esac

	emake built-sources
	emake bootctl man/bootctl.1 linux${EFI_MT}.efi.stub systemd-boot${EFI_MT}.efi
}

src_install() {
	dobin bootctl
	doman man/bootctl.1
	insinto usr/lib/systemd/boot/efi
	doins linux${EFI_MT}.efi.stub systemd-boot${EFI_MT}.efi
}
