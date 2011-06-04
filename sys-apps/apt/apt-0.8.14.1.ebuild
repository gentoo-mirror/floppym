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
#IUSE="nls"
IUSE=""

RDEPEND="app-arch/dpkg
	net-misc/curl
	sys-libs/db
	sys-libs/zlib"
DEPEND="${RDEPEND}
	app-doc/doxygen
	app-text/debiandoc-sgml
	app-text/docbook-xml-dtd
	app-text/docbook-xsl-stylesheets
	app-text/po4a
	dev-libs/libxslt
	media-gfx/graphviz
	sys-devel/gettext
	sys-devel/gnuconfig"

src_prepare() {
	# These are shipped as (broken) symlinks
	rm buildlib/config.{guess,sub} || die
	cp /usr/share/gnuconfig/config.{guess,sub} buildlib || die

	epatch "${FILESDIR}/${PN}-docbook-path.patch"
}

src_configure() {
	# The doxygen makefile has ../build hardcoded
	mkdir build || die
	cd build || die
	ECONF_SOURCE="${S}" econf
}

src_compile() {
	cd build || die
	emake
}

src_install() {
	dobin build/bin/apt-*
	dolib.so build/bin/libapt*

	exeinto /usr/$(get_libdir)/apt/methods
	doexe build/bin/methods/*

	exeinto /usr/$(get_libdir)/dpkg/methods/apt
	doexe build/scripts/dselect/{install,setup,update}
	insinto /usr/$(get_libdir)/dpkg/methods/apt
	doins build/scripts/dselect/{desc.apt,names}

	doman doc/*.[158] doc/*/*.[158]

	insinto /usr/include
	doins -r build/include/apt-pkg

	insinto /usr/share
	doins -r build/locale

	insinto /etc/apt
	doins build/docs/examples/sources.list

	insinto /etc/apt.conf.d
	newins debian/apt.conf.autoremove 01autoremove

	insinto /etc/cron.daily
	newins debian/apt.cron.daily apt

	insinto /etc/logrotate.d
	newins debian/apt.logrotate apt

	dodoc debian/{changelog,NEWS}
	dodoc -r build/docs/examples

	dodoc build/docs/*.text
	dohtml -r build/docs/*.html
}
