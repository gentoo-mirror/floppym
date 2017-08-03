# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Go library for the Cloudflare v4 API"
HOMEPAGE="https://github.com/cloudflare/cloudflare-go"
SRC_URI="https://github.com/cloudflare/cloudflare-go/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

EGO_PN="github.com/cloudflare/cloudflare-go"
