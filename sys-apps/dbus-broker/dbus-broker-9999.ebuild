# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 meson

DESCRIPTION="Linux D-Bus Message Broker"
HOMEPAGE="https://github.com/bus1/dbus-broker/wiki"
EGIT_REPO_URI="https://github.com/bus1/dbus-broker.git"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="audit selinux test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/expat-2.2
	>=dev-libs/glib-2.50:2
	>=sys-apps/systemd-230
	audit? ( sys-process/audit )
	selinux? ( sys-libs/libselinux )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( >=sys-apps/dbus-1.10 )
"

src_configure() {
	local emesonargs=(
		-D audit=$(usex audit true false)
		-D selinux=$(usex selinux true false)
	)
	meson_src_configure
}
