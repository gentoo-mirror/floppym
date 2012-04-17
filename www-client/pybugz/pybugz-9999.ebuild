# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/pybugz/pybugz-9999.ebuild,v 1.10 2012/03/02 08:11:33 williamh Exp $

EAPI=3
PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-pypy-*"
PYTHON_MODNAME="bugz"
PYTHON_USE_WITH="readline"

if [ "${PV}" = "9999" ]; then
	#EGIT_REPO_URI="git://github.com/floppym/pybugz.git"
	EGIT_REPO_URI="/home/floppym/src/pybugz"
	EGIT_BRANCH="py3"
	vcs=git-2
else
	SRC_URI="http://www.github.com/williamh/${PN}/tarball/${PV} -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
	GITHUB_COMMIT=573903e
	S="${WORKDIR}/williamh-pybugz-${GITHUB_COMMIT}"
fi

inherit $vcs bash-completion-r1 distutils

DESCRIPTION="Command line interface to (Gentoo) Bugzilla"
HOMEPAGE="http://www.github.com/williamh/pybugz"
LICENSE="GPL-2"
SLOT="0"
IUSE="zsh-completion"

RDEPEND="${DEPEND}
	zsh-completion? ( app-shells/zsh )"

DOCS="bugzrc.example"

src_install() {
	distutils_src_install

	doman man/bugz.1
	newbashcomp contrib/bash-completion bugz

	if use zsh-completion ; then
		insinto /usr/share/zsh/site-functions
		newins contrib/zsh-completion _pybugz
	fi
}
