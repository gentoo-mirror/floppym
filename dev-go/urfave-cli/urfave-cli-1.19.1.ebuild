# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

DESCRIPTION="A simple, fast, and fun package for building command line apps in Go"
HOMEPAGE="https://github.com/urfave/cli"
SRC_URI="https://github.com/urfave/cli/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

EGO_PN="github.com/urfave/cli"
