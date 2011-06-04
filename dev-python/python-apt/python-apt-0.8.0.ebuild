# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS=1
RESTRICT_PYTHON_ABIS="2.4"

inherit distutils

DESCRIPTION="Python interface to libapt-pkg"
HOMEPAGE="http://packages.debian.org/sid/python-apt"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-apps/apt"
DEPEND="${RDEPEND}"

# Used by setup.py
export DEBVER="${PV}"
