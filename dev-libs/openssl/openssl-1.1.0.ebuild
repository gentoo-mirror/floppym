# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-minimal

DESCRIPTION="full-strength general purpose cryptography library (including SSL and TLS)"
HOMEPAGE="https://www.openssl.org/"
SRC_URI="mirror://openssl/source/${P}.tar.gz"

LICENSE="openssl"
SLOT="0/1.1"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_sse2 zlib"

RDEPEND="
	zlib? ( dev-libs/zlib )
"
DEPEND="
	dev-lang/perl
	dev-perl/Text-Template
"

PATCHES=(
	"${FILESDIR}"/1.1.0-flags.patch
	"${FILESDIR}"/1.1.0-rpath.patch
)

src_configure() {
	tc-export AR CC NM RANLIB
	multilib-minimal_src_configure
}

use_ssl() {
	usex "${1}" "enable-${2-${1}}" "no-${2-${1}}"
}

multilib_src_configure() {
	local config=config
	local target=$(bash "${FILESDIR}/gentoo.config")
	[[ -n ${target} ]] && config=Configure

	local conf=(
		"${S}"/${config}
		${target}
		--prefix="${EPREFIX}"/usr
		--libdir="$(get_libdir)"
		--openssldir="${EPREFIX}"/etc/ssl
		$(use_ssl cpu_flags_x86_sse2 sse2)
		$(use_ssl zlib)
	)
	echo "${conf[@]}"
	"${conf[@]}" || die
}
