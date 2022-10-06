# Copyright 2018-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..11} )

inherit python-any-r1

if [[ ${PV} == 9999 ]]; then
	WANT_LIBTOOL=none
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

BDEPEND="test? ( ${PYTHON_DEPS} )"
RDEPEND="sys-libs/readline:0="
DEPEND="${RDEPEND}"

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
	econf --disable-warnings-as-errors
}
