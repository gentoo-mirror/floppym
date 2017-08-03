# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build golang-vcs-snapshot

DESCRIPTION="client for retrieving logs from Cloudflare's Enterprise Log Share service"
HOMEPAGE="https://github.com/cloudflare/logshare"
SRC_URI="https://github.com/cloudflare/logshare/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-go/cloudflare-go
	dev-go/pkg-errors
	dev-go/urfave-cli
"

EGO_PN="github.com/cloudflare/logshare/..."

src_install() {
	golang-build_src_install
	dobin bin/logshare-cli
}
