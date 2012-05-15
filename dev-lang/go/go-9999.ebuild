# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit mercurial toolchain-funcs

DESCRIPTION="Go progamming language"
HOMEPAGE="http://golang.org/"
SRC_URI=""
EHG_REPO_URI="https://code.google.com/p/go"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
RESTRICT="strip"

src_compile() {
	cd src || die
	GOROOT_FINAL="${EPREFIX}/usr/$(get_libdir)/go" \
		bash -x make.bash || die
}

src_test() {
	cd src || die
	GOROOT="${S}" PATH="${S}/bin:${PATH}" \
		bash -x run.bash --no-rebuild || die
}

src_install() {
	local goroot="usr/$(get_libdir)/go"

	dobin bin/*

	insinto "${goroot}"
	doins -r doc lib src
	insinto "${goroot}/pkg"
	doins -r pkg/linux* pkg/obj
	insopts -m0755
	doins -r pkg/tool

	find "${ED}" -type f -exec touch -r "${ED}usr/bin/go" '{}' \;
}
