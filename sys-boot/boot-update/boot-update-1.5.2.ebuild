# Copyright 2010 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="3.*"

inherit python

DESCRIPTION="Funtoo Core Boot Framework for global boot loader configuration"
HOMEPAGE="http://www.funtoo.org/en/funtoo/core/boot"
SRC_URI="http://www.funtoo.org/archive/boot-update/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE=""

src_compile() {
	:
}

src_install() {
	dodoc doc/*.rst

	doman doc/boot-update.8
	doman doc/boot.conf.5

	into /
	dosbin sbin/boot-update

	dodoc etc/boot.conf.example
	insinto /etc
	doins etc/boot.conf

	installing() {
		insinto "$(python_get_sitedir)"
		doins -r funtoo
	}
	cd python/modules || die
	python_execute_function installing
}

pkg_postinst() {
	python_mod_optimize funtoo
}

pkg_postrm() {
	python_mod_cleanup funtoo
}
