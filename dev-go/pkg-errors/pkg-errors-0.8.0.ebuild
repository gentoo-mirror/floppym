# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Simple error handling primitives"
HOMEPAGE="https://github.com/pkg/errors"
SRC_URI="https://github.com/pkg/errors/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

EGO_PN="github.com/pkg/errors"
