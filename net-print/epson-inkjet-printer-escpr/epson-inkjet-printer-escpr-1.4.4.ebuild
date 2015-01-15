# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R)"
HOMEPAGE="http://www.epson.com/"
SRC_URI="https://download3.ebz.epson.net/dsc/f/03/00/03/29/49/36201e41f124a1f4f7b793533b1ade1202032276/epson-inkjet-printer-escpr-1.4.4-1lsb3.2.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"
