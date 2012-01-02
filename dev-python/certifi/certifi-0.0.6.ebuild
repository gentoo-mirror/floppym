# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Mozilla's SSL Certs"
HOMEPAGE="http://python-requests.org/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="app-misc/ca-certificates"

src_install() {
	distutils_src_install
	installing() {
		# Overwrite bundled certificates with a symlink.
		dosym "${EPREFIX}/etc/ssl/certs/ca-certificates.crt" \
			"$(python_get_sitedir -b)/certifi/cacert.pem"
	}
	python_execute_function installing
}
