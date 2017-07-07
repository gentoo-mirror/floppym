# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Green End SFTP Server"
HOMEPAGE="http://www.greenend.org.uk/rjk/sftpserver/"
SRC_URI="http://www.greenend.org.uk/rjk/sftpserver/sftpserver-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

S="${WORKDIR}/sftpserver-${PV}"
