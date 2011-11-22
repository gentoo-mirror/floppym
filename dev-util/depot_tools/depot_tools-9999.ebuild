# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

PYTHON_DEPEND="2"

inherit python subversion

DESCRIPTION="Tools for working with Chromium development"
HOMEPAGE="http://dev.chromium.org/developers/how-tos/depottools"
SRC_URI=""
ESVN_REPO_URI="http://src.chromium.org/svn/trunk/tools/depot_tools"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

src_prepare() {
	# Disable the auto-update script.
	cat > update_depot_tools <<-EOF
	#!/bin/sh
	exit 0
	EOF
	python_convert_shebangs -r 2 .
}

src_install() {
	dodir /opt/${PN}
	mv * "${ED}opt/${PN}" || die

	cat > 80${PN} <<-EOF
	PATH="${EPREFIX}/opt/${PN}"
	EOF
	insinto /etc/env.d
	doins 80${PN}
}

pkg_postinst() {
	python_mod_optimize /opt/${PN}
}

pkg_postrm() {
	python_mod_cleanup /opt/${PN}
}
