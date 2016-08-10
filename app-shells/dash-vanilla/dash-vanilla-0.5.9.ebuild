# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

DESCRIPTION="Debian Almquist shell"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/dash-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+lineno libedit"

DEPEND="libedit? ( dev-libs/libedit )"
RDEPEND="${DEPEND}
	!apps-shells/dash"

S="${WORKDIR}/dash-${PV}"

src_configure() {
	local args=(
		--bindir="${EPREFIX}"/bin
		--enable-fnmatch
		$(use_enable lineno)
		$(use_with libedit)
	)
	econf "${args[@]}"
}
