# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils multilib

DESCRIPTION="Debian's next generation front-end for the dpkg package manager"
HOMEPAGE="http://wiki.debian.org/Apt"
SRC_URI="mirror://debian/pool/main/${P:0:1}/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls"

RDEPEND=""
DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	sys-devel/gnuconfig"

src_prepare() {
	# These are shipped as (broken) symlinks
	rm buildlib/config.{guess,sub} || die
	cp /usr/share/gnuconfig/config.{guess,sub} buildlib || die

	epatch "${FILESDIR}/${PN}-docbook-path.patch"
}

src_configure() {
	econf $(use_enable nls)
}

src_compile() {
	emake NOISY=1
}

src_install() {
	dobin bin/apt-*
	dolib.so bin/libapt-*

	exeinto /usr/$(get_libdir)/apt/methods
	doexe bin/methods/*

	doman doc/*.{1,8}
}
