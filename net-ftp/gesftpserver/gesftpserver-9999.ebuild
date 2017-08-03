# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit python-any-r1

if [[ ${PV} == 9999 ]]; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://github.com/ewxrjk/sftpserver"
else
	SRC_URI="http://www.greenend.org.uk/rjk/sftpserver/sftpserver-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/sftpserver-${PV}"
fi

DESCRIPTION="Green End SFTP Server"
HOMEPAGE="http://www.greenend.org.uk/rjk/sftpserver/"

LICENSE="GPL-2"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	:
}

src_prepare() {
	default
	if [[ ${PV} == 9999 ]]; then
		eautoreconf
	fi
}

src_configure() {
	use test && python_setup
	default
}
