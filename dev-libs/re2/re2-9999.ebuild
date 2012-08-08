# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit multilib toolchain-funcs

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~x86"
	SRC_URI="mirror://gentoo/${P}.tar.xz
		http://dev.gentoo.org/~floppym/distfiles/${P}.tar.xz"
else
	inherit mercurial
	KEYWORDS=""
	EHG_REPO_URI="https://code.google.com/p/re2/"
fi

DESCRIPTION="An efficent, principled regular expression library"
HOMEPAGE="http://code.google.com/p/re2/"

LICENSE="BSD"
SLOT="0"
IUSE=""

src_compile() {
	makeopts=(
		AR="$(tc-getAR)"
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS} -pthread"
		LDFLAGS="${LDFLAGS} -pthread"
		NM="$(tc-getNM)"
	)
	emake "${makeopts[@]}"
}

src_test() {
	emake "${makeopts[@]}" test
}

src_install() {
	emake DESTDIR="${ED}" prefix=usr libdir=usr/$(get_libdir) install
	dodoc AUTHORS CONTRIBUTORS README doc/syntax.txt
	dohtml doc/syntax.html
}
