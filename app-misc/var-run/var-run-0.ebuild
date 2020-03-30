EAPI=7

DESCRIPTION="Dummy package to keep /var/run symlink from being removed"
HOMEPAGE="https://github.com/floppym/floppym"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

S=${WORKDIR}

src_install() {
	keepdir /var/run
}
