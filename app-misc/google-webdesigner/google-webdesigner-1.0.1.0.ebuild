# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit multilib unpacker

DESCRIPTION="Create engaging, interactive HTML5-based designs and motion graphics that can run on any device"
HOMEPAGE="https://www.google.com/webdesigner/"
MY_P="${PN}_${PV}"
SRC_URI="amd64? ( https://dl.google.com/linux/webdesigner/deb/pool/main/g/${PN}/${MY_P}_amd64.deb )
	x86? ( https://dl.google.com/linux/webdesigner/deb/pool/main/g/${PN}/${MY_P}_i386.deb )"

LICENSE="google-chrome"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
"

S=${WORKDIR}
QA_PREBUILT="*"

GWDHOME=opt/google/webdesigner

src_install() {
	mv usr/share/doc/{${PN},${PF}} || die
	doins -r opt usr
	fperms +x /${GWDHOME}/webdesigner
}

pkg_postinst() {
	local lib libdir target

	for libdir in {,usr/}$(get_libdir); do
		lib=${EROOT}${libdir}/libudev.so.1
		if [[ -e ${lib} ]]; then
			target=$(realpath -ms --relative-to="${EROOT}${GWDHOME}" "${lib}")
			ln -fs "${target}" "${EROOT}${GWDHOME}/libudev.so.0"
			break
		fi
	done
}

pkg_prerm() {
	rm -f "${EROOT}${GWDHOME}/libudev.so.0"
}
