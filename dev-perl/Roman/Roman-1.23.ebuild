# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

MODULE_AUTHOR="CHORNY"
MODULE_A_EXT="zip"
inherit perl-module

DESCRIPTION="Perl module for conversion between Roman and Arabic numerals"

LICENSE="|| ( Artistic GPL-1 GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="test? ( dev-perl/Test-Pod dev-perl/Test-Pod-Coverage )"

SRC_TEST="do"
