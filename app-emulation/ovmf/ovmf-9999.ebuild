# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit git-r3 toolchain-funcs

DESCRIPTION="OVMF"
HOMEPAGE="http://www.tianocore.org/ovmf/"
EGIT_REPO_URI="https://github.com/tianocore/edk2"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="sys-power/iasl"

S="${WORKDIR}/${P}/OvmfPkg"

src_compile() {
	tc-export CC
	unset ARCH
	./build.sh -a X64 --enable-flash || die
}
